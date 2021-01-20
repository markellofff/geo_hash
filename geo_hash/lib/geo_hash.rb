=begin
geohash.rb
// geohash.js
// Geohash library for Javascript
// Thanks to David Troy for his gem pr_geohash
// this is bit modified code of David Troy
// Distributed under the MIT License
=end
# this is GeoHash Module
class GeoHash
  #########
  # Decode from geohash
  #
  # geohash:: geohash code
  # return:: decoded bounding box [[north latitude, west longitude],[south latitude, east longitude]]
  def decode_hash(geohash)
    latlng = [[-90.0, 90.0], [-180.0, 180.0]]
    is_lng = 1
    geohash.downcase.scan(/./) do |c|
      BITS.each do |mask|
        latlng[is_lng][(BASE32.index(c) & mask) == 0 ? 1 : 0] = (latlng[is_lng][0] + latlng[is_lng][1]) / 2
        is_lng ^= 1
      end
    end
    latlng.transpose
  end

  #########
  # Encode latitude and longitude into geohash
  def encode(latitude, longitude, precision = 12)
    latlng = [latitude, longitude]
    points = [[-90.0, 90.0], [-180.0, 180.0]]
    is_lng = 1
    (0...precision).map do
      ch = 0
      5.times do |bit|
        mid = (points[is_lng][0] + points[is_lng][1]) / 2
        points[is_lng][latlng[is_lng] > mid ? 0 : 1] = mid
        ch |=  BITS[bit] if latlng[is_lng] > mid
        is_lng ^= 1
      end
      BASE32[ch, 1]
    end.join
  end

  #########
  # Calculate neighbors (8 adjacents) geohash
  def neighbors(geohash)
    [%i[top right], %i[right bottom], %i[bottom left], %i[left top]].map do |dirs|
      point = adjacent(geohash, dirs[0])
      [point, adjacent(point, dirs[1])]
    end.flatten
  end

  #########
  # Calculate adjacents geohash
  def adjacent(geohash, dir)
    base = geohash[0..-2]
    lastChr = geohash[-1, 1]
    type = geohash.length.odd? ? :odd : :even
    base = adjacent(base, dir) if BORDERS[dir][type].include?(lastChr)
    base + BASE32[NEIGHBORS[dir][type].index(lastChr), 1]
  end

  BITS = [0x10, 0x08, 0x04, 0x02, 0x01].freeze
  BASE32 = '0123456789bcdefghjkmnpqrstuvwxyz'.freeze

  NEIGHBORS = {
    right: { even: 'bc01fg45238967deuvhjyznpkmstqrwx', odd: 'p0r21436x8zb9dcf5h7kjnmqesgutwvy' },
    left: { even: '238967debc01fg45kmstqrwxuvhjyznp', odd: '14365h7k9dcfesgujnmqp0r2twvyx8zb' },
    top: { even: 'p0r21436x8zb9dcf5h7kjnmqesgutwvy', odd: 'bc01fg45238967deuvhjyznpkmstqrwx' },
    bottom: { even: '14365h7k9dcfesgujnmqp0r2twvyx8zb', odd: '238967debc01fg45kmstqrwxuvhjyznp' }
  }.freeze

  BORDERS = {
    right: { even: 'bcfguvyz', odd: 'prxz' },
    left: { even: '0145hjnp', odd: '028b' },
    top: { even: 'prxz', odd: 'bcfguvyz' },
    bottom: { even: '028b', odd: '0145hjnp' }
  }.freeze
end
# module GeoHash

