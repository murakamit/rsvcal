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

  context "has many weeklies" do
    pending ""
  end
end
