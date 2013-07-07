# -*- coding: utf-8 -*-
require 'spec_helper'

describe Weekly do
  let(:group) { Group.create! name: "g" }
  let(:item) { Item.create! group: group, name: "i" }
  let(:args) {
    {
      item: item,
      user: "user",
      wday: 0,
      begin: "2010-01-01  9:00",
      end:   "2010-01-01 10:00",
    }
  }

  describe "user" do
    context "empty, blank" do
      it {
        args.delete :user
        expect(args.has_key? :user).to be_false
        expect { Weekly.create! args }.to raise_error
      }

      [ nil, '', " ", "　", "\n", "\r\n", "\n \n" ].each { |s|
        it {
          args[:user] = s
          expect { w = Weekly.create! args }.to raise_error
        }
      }
    end

    context "size" do
      let(:a0) { "a"  * 50 }
      let(:j0) { "あ" * 50 }
      let(:a1) { "a"  * 51 }
      let(:j1) { "あ" * 51 }

      it {
        args[:user] = a0
        w = nil
        expect { w = Weekly.create! args }.not_to raise_error
        expect { w.update! user: a1 }.to raise_error
      }

      it {
        args[:user] = a1
        expect { Weekly.create! args }.to raise_error
      }

      it {
        args[:user] = j0
        w = nil
        expect { w = Weekly.create! args }.not_to raise_error
        expect { w.update! user: j1 }.to raise_error
      }

      it {
        args[:user] = j1
        expect { Weekly.create! args }.to raise_error
      }
    end
  end # "user"

  describe "wday" do
    (0 .. 6).each { |x|
      it {
        args[:wday] = x
        expect { Weekly.create! args }.not_to raise_error
      }
    }

    it {
      args[:wday] = 7
      w = nil
      expect { w = Weekly.create! args }.not_to raise_error
      expect(w.wday).to eq 0
    }

    it {
      args[:wday] = 8
      expect { Weekly.create! args }.to raise_error
    }
  end # "wday"
end
