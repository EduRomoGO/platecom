# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(:email => 'retiraelcoche@hotmail.com',
            :password => '11111111',
            :plate => '3231HJZ')

User.create(:email => 'ahoramismoloquito@hotmail.com',
            :password => '11111111',
            :plate => '6521DYH')
  let(:user_aux2) {User.create(:email => 'c@c.c',
                       :password => '11111111',
                       :plate => '1234AAA')}
  let(:user_aux3) {User.create(:email => 'd@d.d',
                       :password => '11111111',
                       :plate => '4444DDD')}