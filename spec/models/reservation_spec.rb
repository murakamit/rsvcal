require 'spec_helper'

describe Reservation do
  let(:group) { Group.create! name: "g" }
  let(:item) { Item.create! group: group, name: "i" }
  let(:args) {
    {
      item: item,
      user: "user",
      date: "2013-04-01",
      begin_h: 9,
      begin_m: 0,
      end_h: 10,
      end_m: 0,
    }
  }

  it { expect { Reservation.create! args }.not_to raise_error }

  describe "date" do
    describe "is required" do
      it {
        k = :date
        args.delete k
        expect(args.has_key? k).to be_false
        expect { Reservation.create! args }.to raise_error
      }
    end
  end

  describe "association: item" do
    it {
      n = Reservation.unscoped.size
      expect(item.valid?).to be_true
      id2 = Item.unscoped.last.id + 2
      expect { Item.unscoped.find(id2) }.to raise_error
      args.delete :item
      expect(args.has_key? :item).to be_false
      args[:item_id] = id2
      expect { Reservation.create! args }.to raise_error
      expect(Reservation.unscoped.size).to eq n
    }

    it {
      r = nil
      expect { r = Reservation.create! args }.not_to raise_error
      expect(r.valid?).to be_true
      expect(r.item).to eq item

      id2 = Item.unscoped.last.id + 2
      expect { Item.unscoped.find id2 }.to raise_error
      expect { r.update! item_id: id2 }.to raise_error
      expect(r.valid?).to be_false
      expect(Reservation.unscoped.find(r.id).item_id).to eq item.id
    }
  end
end
