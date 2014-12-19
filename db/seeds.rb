# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


blocked = User.create(:email => 'retiraelcoche@hotmail.com',
            :password => '11111111',
            :plate => '3231HJZ')
blocker = User.create(:email => 'ahoramismoloquito@hotmail.com',
            :password => '11111111',
            :plate => '6521DYH')
User.create(:email => 'c@c.c',
            :password => '11111111',
            :plate => '1234AAA')
User.create(:email => 'd@d.d',
            :password => '11111111',
            :plate => '4444DDD')

 i = Issue.create(:opener_id => blocked.id,
            :receiver_id => blocker.id,
            :description => 'Please, move the car')