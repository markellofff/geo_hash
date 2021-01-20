# geo_hash
Simple Gem for using Geo Hash
GeoHash.new.encode(47.6062095, -122.3320708)
=> "c23nb62w20st"
GeoHash.new.decode_hash("c23nb62w20st")
=> [[47.606209460645914, -122.3320709913969], [47.60620962828398, -122.33207065612078]]
