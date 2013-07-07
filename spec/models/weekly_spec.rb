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
      begin_h: 9,
      begin_m: 0,
      end_h: 10,
      end_m: 0,
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

  describe "begin && end" do
    it {
      w = nil
      args[:begin_h] = 9
      args[:begin_m] = 0
      args[:end_h] = 10
      args[:end_m] = 0
      expect { w = Weekly.create! args }.not_to raise_error
      expect(w.begin_to_s).to eq "9:00"
      expect(w.begin_to_s(2)).to eq "09:00"
      expect(w.end_to_s).to eq "10:00"
      expect(w.end_to_s(2)).to eq "10:00"
      expect { w.update! end_h: 10, end_m: 30 }.not_to raise_error
      expect { w.update! end_h:  8, end_m:  0 }.to raise_error
    }

    it {
      args[:begin_h] = 0
      args[:begin_m] = 0
      args[:end_h] = 0
      args[:end_m] = 30
      expect { Weekly.create! args }.not_to raise_error
    }

    it {
      args[:begin_h] = 24
      args[:begin_m] = 0
      args[:end_h] = 24
      args[:end_m] = 30
      expect { Weekly.create! args }.to raise_error
    }

    it {
      args[:begin_h] = 9
      args[:begin_m] = 0
      args[:end_h] = 9
      args[:end_m] = 30
      expect { Weekly.create! args }.not_to raise_error
    }

    it {
      args[:begin_h] = 9
      args[:begin_m] = 15
      args[:end_h] = 9
      args[:end_m] = 30
      expect { Weekly.create! args }.to raise_error
    }

    it {
      args[:begin_h] = 9
      args[:begin_m] = 0
      args[:end_h] = 9
      args[:end_m] = 0
      expect { Weekly.create! args }.to raise_error
    }

    it {
      args[:begin_h] = 10
      args[:begin_m] = 0
      args[:end_h] = 9
      args[:end_m] = 0
      expect { Weekly.create! args }.to raise_error
    }
  end # "begin, end"

  describe "icon" do
    context "blank" do
      [ nil, '', ' ', "\n", "\r\n" ].each { |s|
        it {
          w = nil
          args[:icon] = s
          expect { w = Weekly.create! args }.not_to raise_error
          expect(w.icon).to eq Weekly.default_icon
        }
      }
    end

    context "HTML Entities" do
      [ "&lt;", "&#60;" ].each { |s|
        it {
          w = nil
          args[:icon] = s
          expect { w = Weekly.create! args }.not_to raise_error
          expect(w.icon).to eq s
        }
      }

      [ "&lt", "&lt; ", "&60;" ].each { |s|
        it {
          w = nil
          args[:icon] = s
          expect { w = Weekly.create! args }.not_to raise_error
          expect(w.icon).to eq "&amp;"
        }
      }

      [ ["&", "&amp;"], ["<", "&lt;"], ["<script>", "&lt;"]  ].each { | ab |
        it {
          a, b = ab
          w = nil
          args[:icon] = a
          expect { w = Weekly.create! args }.not_to raise_error
          expect(w.icon).to eq b
        }
      }

      it {
        w = nil
        args[:icon] = "あいうえお"
        expect { w = Weekly.create! args }.not_to raise_error
        expect(w.icon).to eq "あ"
        expect { w.update! icon: "かきくけこ" }.not_to raise_error
        expect(w.icon).to eq "か"
      }

      it {
        s = "☆"
        w = nil
        args[:icon] = s
        expect { w = Weekly.create! args }.not_to raise_error
        expect(w.icon).to eq s
      }
    end
  end # "icon"

  describe "validates_associated :item" do
    pending ""
  end
end
