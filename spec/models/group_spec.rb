# -*- coding: utf-8 -*-
require 'spec_helper'

describe Group do
  context "no arg" do
    it {
      g = nil
      expect { g = Group.new }.not_to raise_error
      expect(g.save).to be_false
      expect { g.save! }.to raise_error
    }

    it { expect { Group.create! }.to raise_error }
  end

  context "name only" do
    let(:n) { "会議室" }
    let(:g) { Group.create! name: n }
    it { expect(g.name).to eq n }
    it { expect(g.memo).to eq '' }
  end

  context "name & memo" do
    let(:n) { "暗室" }
    let(:m) { "平日のみ" }
    let(:g) { Group.create! name: n, memo: m }
    it { expect(g.name).to eq n }
    it { expect(g.memo).to eq m }
  end

  context "name has white spaces only" do
    [ nil, '', ' ', "　", "\t", "\n",  "\r\n", " \n " ].each { |s|
      it { expect { Group.create! name: s }.to raise_error }

      it {
        g = nil
        expect { g = Group.create! name: "foo" }.not_to raise_error
        expect { g.update! name: s }.to raise_error
      }
    }
  end

  context "memo is blank" do
    let(:n) { "機器" }
    [ '', nil ].each { |m|
      it {
        g = Group.create! name: n, memo: m
        expect(g.name).to eq n
        expect(g.memo).not_to be_nil
        expect(g.memo).to eq ''
      }

      it {
        h = { name: n, memo: "bar" }
        g = nil
        id = nil
        expect { g = Group.create! h }.not_to raise_error
        id = g.id
        expect { g.update!(memo: m) }.not_to raise_error
        expect(g.memo).to eq ''
        expect(Group.find(id).memo).to eq ''
      }
    }
  end

  context "name.size" do
    let(:a0) { "a"  * 50 }
    let(:j0) { "あ" * 50 }
    let(:a1) { "a"  * 51 }
    let(:j1) { "あ" * 51 }
    it {
      g = nil
      expect { g = Group.create! name: a0 }.not_to raise_error
      expect { g.update! name: a1 }.to raise_error
    }
    it { expect { Group.create! name: a1 }.to raise_error }
    it {
      g = nil
      expect { g = Group.create! name: j0 }.not_to raise_error
      expect { g.update! name: j1 }.to raise_error
    }
    it { expect { Group.create! name: j1 }.to raise_error }
  end

  context "name uniq" do
    it {
      pending "care active_only scope"
      n = "foo"
      expect { Group.create! name: n }.not_to raise_error
      expect { Group.create! name: n }.to raise_error
    }
  end

  context "memo.size" do
    let(:a0) { "a"  * 250 }
    let(:j0) { "あ" * 250 }
    let(:a1) { "a"  * 251 }
    let(:j1) { "あ" * 251 }
    it {
      g = nil
      expect { g = Group.create! name: 1, memo: a0 }.not_to raise_error
      expect { g.update! memo: a1 }.to raise_error
    }
    it { expect { Group.create! name: 1, memo: a1 }.to raise_error }
    it {
      g = nil
      expect { g = Group.create! name: 1, memo: j0 }.not_to raise_error
      expect { g.update! memo: j1 }.to raise_error
    }
    it { expect { Group.create! name: 1, memo: j1 }.to raise_error }
  end

  describe "#active?, #removed?, #remove" do
    let(:subject) { Group.create! name: "a" }

    it {
      expect(subject.removed_at).to be <= Group.threshold_remove_utc
      expect(subject.persisted?).to be_true
      expect(subject.active?).to be_true
      expect(subject.removed?).to be_false
    }

    it {
      id = subject.id
      t0 = Time.now.utc.to_s(:db)
      expect(subject.remove).to be_true
      ghost = nil
      expect { ghost = Group.find id }.to raise_error
      expect { ghost = Group.unscoped.find id }.not_to raise_error
      expect(ghost.id).to eq id
      expect(ghost.removed_at).to be >= t0
      expect(ghost).to eq subject
      expect(ghost.persisted?).to be_true
      expect(ghost.active?).to be_false
      expect(ghost.removed?).to be_true
    }
  end

  describe "::active_only, ::removed_only" do
    it {
      expect(Group.unscoped.size).to eq 0
      expect(Group.active_only.size).to eq 0
      expect(Group.removed_only.size).to eq 0
      groups = []
      groups << Group.create!(name: 1)
      expect(Group.unscoped.size).to eq groups.size
      expect(Group.active_only.size).to eq 1
      expect(Group.removed_only.size).to eq 0
      groups << Group.create!(name: 2)
      expect(Group.unscoped.size).to eq groups.size
      expect(Group.active_only.size).to eq 2
      expect(Group.removed_only.size).to eq 0
      n = groups.size
      n.times { |i|
        j = i + 1
        expect(groups[i].remove).to be_true
        expect(Group.unscoped.size).to eq n
        expect(Group.active_only.size).to eq (n-j)
        expect(Group.removed_only.size).to eq j
      }
    }
  end

  describe "relation" do
    context "empty group" do
      it {
        n = Group.all.size
        g = nil
        expect { g = Group.create! name: 1 }.not_to raise_error
        expect(Group.all.size).to eq (n+1)
        expect(g.items.empty?).to be_true
        expect(g.remove).to be_true
        expect(Group.all.size).to eq n
      }
    end

    context "has some items" do
      it {
        n = Group.all.size
        g = nil
        expect { g = Group.create! name: "g" }.not_to raise_error
        expect(Group.all.size).to eq (n+1)
        expect(g.items.empty?).to be_true
        item = nil
        expect { item = g.items.create! name: "i" }.not_to raise_error
        expect(item.group).to eq g
        expect(g.items.include? item).to be_true
        expect(g.items.empty?).to be_false
        expect(g.remove).to be_false
        expect(Group.all.size).to eq (n+1)
      }
    end
  end
end
