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

      it {
        obj = nil
        expect { obj = Group.create! name: "foo" }.not_to raise_error
        expect { obj.update! name: s }.to raise_error
      }
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

      it {
        h = { name: n, memo: "bar" }
        obj = nil
        id = nil
        expect { obj = Group.create! h }.not_to raise_error
        id = obj.id
        expect { obj.update!(memo: m) }.not_to raise_error
        expect(obj.memo).to eq ''
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
      obj = nil
      expect { obj = Group.create! name: a0 }.not_to raise_error
      expect { obj.update! name: a1 }.to raise_error
    }
    it { expect { Group.create! name: a1 }.to raise_error }
    it {
      obj = nil
      expect { obj = Group.create! name: j0 }.not_to raise_error
      expect { obj.update! name: j1 }.to raise_error
    }
    it { expect { Group.create! name: j1 }.to raise_error }
  end

  context "memo.size" do
    let(:a0) { "a"  * 250 }
    let(:j0) { "あ" * 250 }
    let(:a1) { "a"  * 251 }
    let(:j1) { "あ" * 251 }
    it {
      obj = nil
      expect { obj = Group.create! name: 1, memo: a0 }.not_to raise_error
      expect { obj.update! memo: a1 }.to raise_error
    }
    it { expect { Group.create! name: 1, memo: a1 }.to raise_error }
    it {
      obj = nil
      expect { obj = Group.create! name: 1, memo: j0 }.not_to raise_error
      expect { obj.update! memo: j1 }.to raise_error
    }
    it { expect { Group.create! name: 1, memo: j1 }.to raise_error }
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
      objs = []
      objs << Group.create!(name: 1)
      expect(Group.unscoped.size).to eq objs.size
      expect(Group.active_only.size).to eq 1
      expect(Group.removed_only.size).to eq 0
      objs << Group.create!(name: 2)
      expect(Group.unscoped.size).to eq objs.size
      expect(Group.active_only.size).to eq 2
      expect(Group.removed_only.size).to eq 0
      n = objs.size
      n.times { |i|
        j = i + 1
        expect(objs[i].remove).to be_true
        expect(Group.unscoped.size).to eq n
        expect(Group.active_only.size).to eq (n-j)
        expect(Group.removed_only.size).to eq j
      }
    }
  end
end
