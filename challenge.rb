require 'irb'
require 'date'
# Write a function that, given a string representing the list of `M` photos,
#returns the string representing the list of the new names of all photos
#(the order of photos should stay the same).

#group the photos by city
#within each such group sort the photos by the time they were taken
#finally assign consecutive natural numbers to the photos, starting from 1
#rename all the photos.
#new name of each photo should begin with the name of the city followed by the number already assigned to that photo.
#The number of every photo in each group should have the same length (equal to the length of the largest number in this group);
#thus, Mike needs to add some leading zeros to the numbers.
#The new name of the photo should end with the extension, which should remain the same. Your task is to help Mike
#Each photo has the format: '<\<photoname>>.<\<extension>>, <<city_name>>, yyyy-mm-dd, hh:mm:ss",
#where '<<photo_name>>', '<\<extension>>' and, '<<city_name>>' consist only of letters of the English alphabet.

###assumptions###
# `M` is an integer within the range (1..100);
# Each year is an integer within the range (2000..2020);
# Each line of the input string is of the format'<\<photoname>>.<\<extension>>, <<city_name>>, yyyy-mm-dd hh:mm:ss' and lines are separated with newline characters;
# Each photo name (without extension) and city name
#name consists only of at least 1 and at most 20 letters from the Englishalphabet;
# Each name of the city starts with a capital letters and is followed bylower case letters;
# No two photos from the same location share the same date and time;
# Each extension is "jpg", "png" or "jpeg". In your solution, focus on correctness.

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

expected_output = "Krakow02.jpg
London1.png
Krakow01.png
Florianopolis2.jpg
Florianopolis1.jpg
London2.jpg
Florianopolis3.png
Krakow03.jpg
Krakow09.png
Krakow07.jpg
Krakow06.jpg
Krakow08.jpg
Krakow04.png
Krakow05.png
Krakow10.jpg"

#TO DO:
#split string into a hash with keys: name, ext?, city, datetime, index? --> DONE
#group hash by city, then sort by datetime --> DONE
#assign number determine new photo name --> DONE
# return new string --> DONE

def parse_photos_from_string(string)
  arr = string.split("\n")
  new_arr = arr.map.with_index {|photo, index| parse_photo_details(photo, index) }
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

def group_and_sort(photo_arr)
  grouped_photos = photo_arr.group_by { |photo| photo[:city] }

  sorted_photos = {}
  grouped_photos.each do |city, photos|
    sorted_photos[city] = photos.sort_by { |photo| photo[:datetime] }
  end
  sorted_photos
end

def determine_new_photo_names(photo_hash)
  photo_hash.each do |city, photos|
    count = photos.length
    len = count/10 + 1
    photos.each_with_index do |photo, i|
      num = (i + 1).to_s
      photo[:new_name] = "#{city}#{num.rjust(len, '0')}"
    end
  end
end

def print_new_photo_str(photo_hash)
  photo_hash.flat_map {|city, photos| photos }.sort_by { |photo| photo[:index] }.map { |photo| puts "#{[photo[:new_name], photo[:ext]].join('.')}" }
end

photo_arr = parse_photos_from_string(test_str)
sorted_photos = group_and_sort(photo_arr)
new_name_photos = determine_new_photo_names(sorted_photos)
print_new_photo_str(new_name_photos)
