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

  describe "#remove" do
    pending ""
    it {
      obj = Group.create! name: 1
      expect(obj)
    }
  end

  describe "#remove!" do
    pending ""
  end

  describe "#removed?" do
    pending ""
  end

  describe "#active?" do
    pending ""
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
