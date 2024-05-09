require 'irb'
require 'date'

def parse_photos_from_string(string)
  string.split("\n").map.with_index {|photo, index| parse_photo_details(photo, index) }
end

def parse_photo_details(photo, index)
  arr = photo.split(',')
  photo_name, photo_ext = arr[0].split('.')
  city = arr[1].strip
  date_str = arr[2].strip
  datetime = DateTime.strptime(date_str, "%Y-%m-%d %H:%M:%S")
  index = index

  { name: photo_name, ext: photo_ext, city: city, datetime: datetime, index: index}
end

def group_and_sort_photos(photo_arr)
  grouped_photos = photo_arr.group_by { |photo| photo[:city] }

  sorted_photos = {}
  grouped_photos.each do |city, photos|
    sorted_photos[city] = photos.sort_by { |photo| photo[:datetime] }
  end
  sorted_photos
end

def determine_new_photo_names(photo_hash)
  photo_hash.each do |city, photos|
    photos.map.with_index(1) do |photo, i|
      photo[:new_name] = "#{city}#{i.to_s.rjust(photos.length/10 + 1, '0')}"
    end
  end
end

def output_new_photo_str(photo_hash)
  photo_names = photo_hash.flat_map {|city, photos| photos }
                          .sort_by { |photo| photo[:index] }
                          .map { |photo| "#{photo[:new_name]}.#{photo[:ext]}" }
  photo_names.join("\n")
end

def solution(str)
  photo_arr = parse_photos_from_string(str)                     # turns string into an a array of hashes that contain photo details
  sorted_photos = group_and_sort_photos(photo_arr)              # groups photos by city and sorts each group by date
  new_name_photos = determine_new_photo_names(sorted_photos)    # creates new photo name based on city and photo count per city

  output_new_photo_str(sorted_photos)                           # returns string of newly named photos in the original input order
end

test_str = "photo.jpg, Krakow, 2013-09-05 14:08:15
Mike.png, London, 2015-06-20 15:13:22
myFriends.png, Krakow, 2013-09-05 14:07:13
Eiffel.jpg, Florianopolis, 2015-07-23 08:03:02
pisatower.jpg, Florianopolis, 2015-07-22 23:59:59
BOB.jpg, London, 2015-08-05 00:02:03
notredame.png, Florianopolis, 2015-09-01 12:00:00
me.jpg, Krakow, 2013-09-06 15:40:22
a.png, Krakow, 2016-02-13 13:33:50
b.jpg, Krakow, 2016-01-02 15:12:22
c.jpg, Krakow, 2016-01-02 14:34:30
d.jpg, Krakow, 2016-01-02 15:15:01
e.png, Krakow, 2016-01-02 09:49:09
f.png, Krakow, 2016-01-02 10:55:32
g.jpg, Krakow, 2016-02-29 22:13:11"

puts solution(test_str)
