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
            password: "123",
            password_confirmation: "123")

g1 = Group.create(name: "会議室")

%w(１ ２ ３).each { |s|
  Item.create(group_id: g1.id, name: (g1.name + s))
}
