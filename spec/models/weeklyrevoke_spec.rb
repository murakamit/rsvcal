# -*- coding: utf-8 -*-
require 'spec_helper'

describe Weeklyrevoke do
  let(:group) { Group.create! name: "g" }
  let(:item) { Item.create! group: group, name: "i" }

  let(:weekly) {
    h =  {
      item: item,
      user: "u",
      date_begin: "2013-04-01",
      begin_h: 9,
      begin_m: 0,
      end_h: 10,
      end_m: 0,
    }
    Weekly.create! h
  }

  let(:args) {
    {
      weekly: weekly,
      applicant: "a",
      date: "2013-04-08"
    }
  }

  it { expect { Weeklyrevoke.create! args }.not_to raise_error }

  describe "applicant" do
    it {
      k = :applicant
      args.delete k
      expect(args.has_key? k).to be_false
      expect { Weeklyrevoke.create! args }.to raise_error
    }

    describe "is required" do
      [ nil, '', ' ', "　", "\n", "\r\n", "\n \n" ].each { |s|
        it {
          args[:applicant] = s
          expect { Weeklyrevoke.create! args }.to raise_error
        }
      }
    end

    describe "is less than 50 chars" do
      [ 'a', "あ" ].each { |c|
        it {
          args[:applicant] = c * 50
          expect { Weeklyrevoke.create! args }.not_to raise_error
          args[:applicant] += c
          expect { Weeklyrevoke.create! args }.to raise_error
        }
      }
    end
  end # applicant

  describe "date" do
    describe "is required" do
      it {
        k = :date
        args.delete k
        expect(args.has_key? k).to be_false
        expect { Weeklyrevoke.create! args }.to raise_error
      }
    end

    describe "must be valid" do
      [ nil, '', ' ', "\n", "\r\n", "2013-04-71" ].each { |d|
        it {
          args[:date] = d
          expect { Weeklyrevoke.create! args }.to raise_error
        }
      }
    end

    describe "r.date.wday == r.weekly.wday" do
      it {
        d = weekly.date_begin
        args[:date] = d + 1.week
        expect { Weeklyrevoke.create! args }.not_to raise_error
        args[:date] = d + 1.week + 1.day
        expect { Weeklyrevoke.create! args }.to raise_error
      }
    end

    describe "r.weekly.date_begin <= r.date <= r.weekly.date_end" do
      it {
        d1 = weekly.date_begin
        d2 = d1 + 3.weeks
        weekly.date_end = d2
        expect { weekly.save! }.not_to raise_error
        expect(weekly.valid?).to be_true

        args[:date] = d1 - 1.week
        expect { Weeklyrevoke.create! args }.to raise_error
        args[:date] = d1
        expect { Weeklyrevoke.create! args }.not_to raise_error
        args[:date] = d1 + 1.week
        expect { Weeklyrevoke.create! args }.not_to raise_error
        args[:date] = d2
        expect { Weeklyrevoke.create! args }.not_to raise_error
        args[:date] = d2 + 1.week
        expect { Weeklyrevoke.create! args }.to raise_error
      }      
    end
  end # "date"

  describe "association: weekly" do
    it {
      n = Weeklyrevoke.unscoped.size
      expect(weekly.valid?).to be_true
      id2 = Weekly.unscoped.last.id + 2
      expect { Weekly.unscoped.find(id2) }.to raise_error
      args.delete :weekly
      expect(args.has_key? :weekly).to be_false
      args[:weekly_id] = id2
      expect { Weeklyrevoke.create! args }.to raise_error
      expect(Weeklyrevoke.unscoped.size).to eq n
    }

    it {
      r = nil
      expect { r = Weeklyrevoke.create! args }.not_to raise_error
      expect(r.valid?).to be_true
      expect(r.weekly).to eq weekly

      id2 = Weekly.unscoped.last.id + 2
      expect { Weekly.unscoped.find id2 }.to raise_error
      expect { r.update! weekly_id: id2 }.to raise_error
      expect(r.valid?).to be_false
      expect(Weeklyrevoke.unscoped.find(r.id).weekly_id).to eq weekly.id
    }
  end # association
end
