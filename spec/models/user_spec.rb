# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  let(:args) {
    {
      name: "foo",
      password: "123", 
      password_confirmation: "123",
    }
  }

  it { expect { User.create! args }.not_to raise_error }

  describe "password & password_confirmation" do
    describe "is required" do
      it {
        h = { name: "foo" }
        expect { User.create! h }.to raise_error
        h[:password] = "123"
        expect { User.create! h }.to raise_error
        h[:password_confirmation] = "123"
        expect { User.create! h }.not_to raise_error
      }

      it {
        h = { name: "foo",  password: "123", password_confirmation: "456" }
        expect { User.create! h }.to raise_error
      }

      [ nil, '', ' ', "　", "\n", "\r\n", "\n \n"  ].each { |s|
        it {
          args[:name] = s
          expect { User.create! args }.to raise_error
        }
      }

      [ nil, '', ' ', "　", "\n", "\r\n", "\n \n"  ].each { |s|
        it {
          args[:password] = s
          args[:password_confirmation] = s
          expect { User.create! args }.to raise_error
        }
      }
    end
  end # password & password_confirmation

  describe "admin" do
    describe "is optional" do
      it {
        expect(args.has_key? :admin).to be_false
        u = nil
        expect { u = User.create! args }.not_to raise_error
        expect(u.valid?).to be_true
        expect(u.admin?).to be_false
      }
    end

    context "nil, ''" do
      [ nil, '' ].each { |s|
        it {
          u = nil
          args[:admin] = s
          expect { u = User.create! args }.to raise_error
        }
      }
    end

    context "white" do
      [ ' ', "　", "\n", "\r\n", "\n \n" ].each { |s|
        it {
          u = nil
          args[:admin] = s
          expect { u = User.create! args }.not_to raise_error
          expect(u.valid?).to be_true
          expect(u.admin?).to be_false
        }
      }
    end

    context "true, 1, '1'" do
      [ true, 1, '1' ].each { |x|
        it {
          u = nil
          args[:admin] = x
          expect { u = User.create! args }.not_to raise_error
          expect(u.valid?).to be_true
          expect(u.admin?).to be_true
        }
      }
    end

    context do
      [ false, 0, :"1", 2, "2", :"2", 'admin' ].each { |x|
        it {
          u = nil
          args[:admin] = x
          expect { u = User.create! args }.not_to raise_error
          expect(u.valid?).to be_true
          expect(u.admin?).to be_false
        }
      }
    end
  end # admin
end
