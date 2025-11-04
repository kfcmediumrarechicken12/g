class GeoHelper
  R = 6378100   # radius of the earth in m

  def self.distance(lat1, lon1, lat2, lon2)
    # https://stackoverflow.com/a/27943

    dLat = self.deg2rad(lat2 - lat1)
    dLon = self.deg2rad(lon2 - lon1)
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(self.deg2rad(lat1)) * Math.cos(self.deg2rad(lat2)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    R * c  # distance in m
  end

  def self.deg2rad(d)
    d * Math::PI / 180
  end
end

class Event
    attr_accessor :name, :type, :lat, :lon, :time

    def initialize(eventString)
      @name, @type, latStr, lonStr, timeStr = eventString.split(":")
      @lat = latStr.to_f
      @lon = lonStr.to_f
      @time = timeStr.to_i
    end

    def to_s
      "#{@name} (#{@type}) at #{@lat}, #{@lon} time #{@time}"
    end
  end

class EventManager
  def initialize(eventList)
    @events = eventList.map { |e| Event.new(e) }
  end

  def findEventsNear(lat, lon, maxDist = 5000)
    @events.select do |event|
      GeoHelper.distance(lat, lon, event.lat, event.lon) < maxDist
    end
  end

  def findEarthquakesNear(cityName)
    city = @events.find { |e| e.name == cityName && e.type == "city" }
    return [] unless city

    @events.select do |e|
      e.type == "earthquake" &&
      GeoHelper.distance(e.lat, e.lon, city.lat, city.lon) < 5000
    end
  end

  def addVolcanoEvent(name, lat, lon, time)
    @events << Event.new("#{name}:volcano:#{lat}:#{lon}:#{time}")
  end

  def addEarthquakeEvent(name, lat, lon, time)
    @events << Event.new("#{name}:earthquake:#{lat}:#{lon}:#{time}")
  end

  def addGeyser(name, lat, lon, time)
    @events << Event.new("#{name}:geyser:#{lat}:#{lon}:#{time}")
  end

  def addHotspring(name, lat, lon)
    @events << Event.new("#{name}:hotspring:#{lat}:#{lon}:-1")
  end

  def addFumarole(name, lat, lon)
    @events << Event.new("#{name}:fumarole:#{lat}:#{lon}:-1")
  end

  def addCity(name, lat, lon)
    @events << Event.new("#{name}:city:#{lat}:#{lon}:-1")
  end
end

starting_events = [
  "some volcano:volcano:40.12120:-121.3455:21451",
  "some earthquake:earthquake:40.51230:-121.23425:87153",
  "another earthquake:earthquake:39.23890:-120.23985:17354",
  "yet another earthquake:earthquake:39.23223:-120.23125:16524",
  "another volcano:volcano:43.32890:-122.3289:23856",
  "a geyser:geyser:39.23223:-120.23125",
  "Townville:city:44.05645:-121.30812"
]

em = EventManager.new(starting_events)

em.addHotspring("my favorite hotspring", 46.1231, -115.23234)
em.addCity("Cityton", 40.5232, -121.23453)
em.addVolcanoEvent("yet another volcano", 15.52232, -107.03521, 256923)

x = em.findEventsNear(40.5, -121.2, 163000)
pp x

puts "------------------------"

x = em.findEarthquakesNear("Cityton")
pp x