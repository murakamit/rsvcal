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

  context "group & name" do
    pending ""
  end

  context "name only" do
    it { expect { Item.create! name: "会議室２" }.to raise_error }
  end

  # context "group & name & memo" do
  #   let(:g) { 1 }
  #   let(:n) { "会議室２" }
  #   let(:m) { "10名まで" }
  #   let(:obj) {
  #     x = Item.new name: n, memo: m
  #     x.group = g
  #     x.save!
  #     x
  #   }
  #   it { expect(obj.group).to eq g }
  #   it { expect(obj.name).to eq n }
  #   it { expect(obj.memo).to eq m }
  # end

  # context "name has white spaces only" do
  #   [ nil, '', ' ', "　", "\t", "\n",  "\r\n", " \n " ].each { |s|
  #     it { expect { Item.create! name: s }.to raise_error }
  #   }
  # end

  # context "memo is blank" do
  #   let(:n) { "機器" }
  #   [ '', nil ].each { |m|
  #     it {
  #       obj = Item.create! name: n, memo: m
  #       expect(obj.name).to eq n
  #       expect(obj.memo).not_to be_nil
  #       expect(obj.memo).to eq ''
  #     }
  #   }
  # end
end
