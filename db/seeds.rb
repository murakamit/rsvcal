# -*- coding: utf-8;  -*-

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: "admin",
            admin: true,
            password: "admin",
            password_confirmation: "admin")

g1 = Group.create(name: "部屋")

[["会議室", "201室"], ["暗室", "301室"]].each { |a|
  name, memo = a
  Item.create(group_id: g1.id, name: name, memo: memo)
}

g2 = Group.create(name: "機器")
Item.create(group_id: g2.id, name: "電子顕微鏡", memo: "302室")
