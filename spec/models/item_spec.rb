# -*- coding: utf-8 -*-
require 'spec_helper'

describe Item do
  context "no arg" do
    it {
      item = nil
      expect { item = Item.new }.not_to raise_error
      expect(item.save).to be_false
      expect { item.save! }.to raise_error
    }

    it { expect { Item.create! }.to raise_error }
  end

  context "group only" do
    it {
      g = nil
      expect { g = Group.create! name: "g" }.not_to raise_error
      expect { item = Item.create! group: g }.to raise_error
    }
  end

  context "name only" do
    it { expect { Item.create! name: 1 }.to raise_error }
  end

  context "group & name; belongs_to group" do
    it {
      g = nil
      expect { g = Group.create! name: "g" }.not_to raise_error
      expect(g.items.empty?).to be_true
      n = "会議室"
      item = nil
      expect { item = Item.create! group: g, name: n }.not_to raise_error
      expect(item.group).to eq g
      expect(g.items.include? item).to be_true
      expect(g.items.empty?).to be_false

      expect(g.remove).to be_false
      expect(item.remove).to be_true
      expect(g.items.empty?).to be_true
      expect(g.remove).to be_true
    }
  end

  describe "association :group" do
    it {
      n = Item.unscoped.size
      expect(Group.unscoped.empty?).to be_true
      expect { Group.unscoped.find(1) }.to raise_error
      expect { Item.create! group_id: 1, name: "foo" }.to raise_error
      expect(Item.unscoped.size).to eq n
    }

    it {
      g = nil
      expect { g = Group.create! name: "g" }.not_to raise_error
      expect(g.valid?).to be_true
      expect(Group.unscoped.empty?).to be_false
      obj = nil
      expect { obj = Item.create! group: g, name: "foo" }.not_to raise_error
      expect(obj.valid?).to be_true
      expect(obj.group).to eq g

      gid2 = g.id + 2
      expect { Group.find gid2 }.to raise_error
      expect { obj.update! group_id: gid2 }.to raise_error
      expect(obj.valid?).to be_false
      expect(Item.find(obj.id).group_id).to eq g.id
    }
  end
end
