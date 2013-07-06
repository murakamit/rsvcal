# coding: utf-8
require 'spec_helper'

describe Item do
  context "no arg" do
    it {
      obj = nil
      expect { obj = Item.new }.not_to raise_error
      expect(obj.save).to be_false
      expect { obj.save! }.to raise_error
    }

    it { expect { Item.create! }.to raise_error }
  end

  context "group only" do
    pending ""
  end

  context "name only" do
    it { expect { Item.create! name: "会議室２" }.to raise_error }
  end

  context "group & name" do
    pending ""
  end

  describe "relation" do
    pending ""
  end
end
