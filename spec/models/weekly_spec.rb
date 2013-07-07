# -*- coding: utf-8 -*-
require 'spec_helper'

describe Weekly do
  context "user.size" do
    let(:g) { Group.create! name: "g" }
    let(:i) { Item.create! group: g, name: "i" }
    let(:h) {
      {
        item: i,
        wday: 0,
        begin: "2010-01-01  9:00",
        end:   "2010-01-01 10:00",
      }
    }
    let(:a0) { "a"  * 50 }
    let(:j0) { "あ" * 50 }
    let(:a1) { "a"  * 51 }
    let(:j1) { "あ" * 51 }
    it {
      h[:user] = a0
      w = nil
      expect { w = Weekly.create! h }.not_to raise_error
      expect { w.update! user: a1 }.to raise_error
    }
    it { expect { Weekly.create! user: a1 }.to raise_error }
    it {
      h[:user] = j0
      w = nil
      expect { w = Weekly.create! h }.not_to raise_error
      expect { w.update! user: j1 }.to raise_error
    }
    it { expect { Weekly.create! user: j1 }.to raise_error }
  end
end
