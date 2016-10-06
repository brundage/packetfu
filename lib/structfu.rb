# -*- coding: binary -*-
# StructFu, a nifty way to leverage Ruby's built in Struct class
# to create meaningful binary data. 

module StructFu

  autoload :Int, 'structfu/int'
  autoload :Int8, 'structfu/int8'
  autoload :Int16, 'structfu/int16'
  autoload :Int16be, 'structfu/int16be'
  autoload :Int16le, 'structfu/int16le'
  autoload :Int32, 'structfu/int32'
  autoload :Int32be, 'structfu/int32be'
  autoload :Int32le, 'structfu/int32le'
  autoload :Int64, 'structfu/int64'
  autoload :Int64be, 'structfu/int64be'
  autoload :Int64le, 'structfu/int64le'
  autoload :String, 'structfu/string'
  autoload :IntString, 'structfu/int_string'
  
  # Normally, self.size and self.length will refer to the Struct
  # size as an array. It's a hassle to redefine, so this introduces some
  # shorthand to get at the size of the resultant string.
  def sz
    self.to_s.size
  end
  alias len sz


  # Typecast is used mostly by packet header classes, such as IPHeader,
  # TCPHeader, and the like. It takes an argument, and casts it to the
  # expected type for that element. 
  def typecast(i)
    c = caller[0].match(/.*`([^']+)='/)[1]
    self[c.intern].read i
  end


  # Used like typecast(), but specifically for casting Strings to StructFu::Strings.
  def body=(i)
    if i.kind_of? ::String
      typecast(i)
    elsif i.kind_of? StructFu
      self[:body] = i
    elsif i.nil?
      self[:body] = StructFu::String.new.read("")
    else
      raise ArgumentError, "Can't cram a #{i.class} into a StructFu :body"
    end
  end


  # Handle deep copies correctly. Marshal in 1.9, re-read myself on 1.8
  def clone
    begin
      Marshal.load(Marshal.dump(self))
    rescue
      self.class.new.read(self.to_s)
    end
  end


  # Set the endianness for the various Int classes. Takes either :little or :big
  def set_endianness(e=nil)
    unless [:little, :big].include? e
      raise ArgumentError, "Unknown endianness (#{e}) for #{self.class}"
    end
    @int64 = e == :little ? Int64le : Int64be
    @int32 = e == :little ? Int32le : Int32be
    @int16 = e == :little ? Int16le : Int16be
    return e
  end

end

class Struct

  # Monkeypatch for Struct to include some string safety -- anything that uses
  # Struct is going to presume binary strings anyway.
  def force_binary(str)
    PacketFu.force_binary(str)
  end

end

# vim: nowrap sw=2 sts=0 ts=2 ff=unix ft=ruby
