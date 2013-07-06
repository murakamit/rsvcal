# coding: utf-8
require 'spec_helper'

describe Group do
  context "no arg" do
    it {
      obj = nil
      expect { obj = Group.new }.not_to raise_error
      expect(obj.save).to be_false
      expect { obj.save! }.to raise_error
    }

    it { expect { Group.create! }.to raise_error }
  end

  context "name only" do
    let(:n) { "会議室" }
    let(:obj) { Group.create! name: n }
    it { expect(obj.name).to eq n }
    it { expect(obj.memo).to eq '' }
  end

  context "name & memo" do
    let(:n) { "暗室" }
    let(:m) { "平日のみ" }
    let(:obj) { Group.create! name: n, memo: m }
    it { expect(obj.name).to eq n }
    it { expect(obj.memo).to eq m }
  end

  context "name has white spaces only" do
    [ nil, '', ' ', "　", "\t", "\n",  "\r\n", " \n " ].each { |s|
      it { expect { Group.create! name: s }.to raise_error }
    }
  end

  context "memo is blank" do
    let(:n) { "機器" }
    [ '', nil ].each { |m|
      it {
        obj = Group.create! name: n, memo: m
        expect(obj.name).to eq n
        expect(obj.memo).not_to be_nil
        expect(obj.memo).to eq ''
      }
    }
  end

  describe "#active?, #removed?, #remove" do
    let(:subject) { Group.create! name: "a" }

    it {
      expect(subject.removed_at).to be <= Group.threshold_time
      expect(subject.persisted?).to be_true
      expect(subject.active?).to be_true
      expect(subject.removed?).to be_false
    }

    it {
      id = subject.id
      expect(subject.remove).to be_true
      ghost = nil
      expect { ghost = Group.find id }.to raise_error
      expect { ghost = Group.unscoped.find id }.not_to raise_error
      expect(ghost.id).to eq id
      expect(ghost).to eq subject
      expect(ghost.persisted?).to be_true
      expect(ghost.active?).to be_false
      expect(ghost.removed?).to be_true
    }
  end

  describe "::removed_only" do
    pending ""
  end

  describe "::active_only" do
    pending ""
  end

  # describe "::active_ids" do
  #   let(:num) { 5 }
  #   let(:objary) {
  #     num.times { |i| Group.create! name: i }
  #     Group.all
  #   }
  #   it { expect(objary.size).to eq num }
  #   it {
  #     a = []
  #     objary.each { |o| a << o.id }
  #     a.sort!
  #     a.uniq!
  #     expect(a.size).to eq num
  #     expect(Group.valid_ids).to eq a
  #   }
  # end
end
