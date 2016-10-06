# -*- coding: binary -*-
module PacketFu
  # PcapFile is a complete libpcap file struct, made up of two elements, a 
  # PcapHeader and PcapPackets.
  #
  # See http://wiki.wireshark.org/Development/LibpcapFileFormat
  #
  # PcapFile also can behave as a singleton class, which is usually the better
  # way to handle pcap files of really any size, since it doesn't require
  # storing packets before handing them off to a given block. This is really
  # the way to go.
  class PcapFile < Struct.new(:endian, :head, :body)
    include StructFu

    class << self

      # Takes a given file and returns an array of the packet bytes. Here 
      # for backwards compatibilty.
      def file_to_array(fname)
        PcapFile.new.file_to_array(:f => fname)
      end

      # Takes a given file name, and reads out the packets. If given a block,
      # it will yield back a PcapPacket object per packet found.
      def read(fname,&block) 
        file_header = PcapHeader.new
        pcap_packets = PcapPackets.new 
        unless File.readable? fname
          raise ArgumentError, "Cannot read file `#{fname}'"
        end
        begin
        file_handle = File.open(fname, "rb")
        file_header.read file_handle.read(24)
        packet_count = 0
        pcap_packet = PcapPacket.new(:endian => file_header.endian)
        while pcap_packet.read file_handle.read(16) do
          len = pcap_packet.incl_len
          pcap_packet.data = StructFu::String.new.read(file_handle.read(len.to_i))
          packet_count += 1
          if pcap_packet.data.size < len.to_i
            warn "Packet ##{packet_count} is corrupted: expected #{len.to_i}, got #{pcap_packet.data.size}. Exiting."
            break
          end
          if block
            yield pcap_packet
          else
            pcap_packets << pcap_packet.clone
          end
        end
        ensure
          file_handle.close
        end
        block ? packet_count : pcap_packets
      end

      # Takes a filename, and an optional block. If a block is given, 
      # yield back the raw packet data from the given file. Otherwise,
      # return an array of parsed packets.
      def read_packet_bytes(fname,&block)
        count = 0
        packets = [] unless block
        read(fname) do |packet| 
          if block
            count += 1
            yield packet.data.to_s
          else
            packets << packet.data.to_s
          end
        end
        block ? count : packets
      end

      alias :file_to_array :read_packet_bytes 

      # Takes a filename, and an optional block. If a block is given,
      # yield back parsed packets from the given file. Otherwise, return
      # an array of parsed packets.
      #
      # This is a brazillian times faster than the old methods of extracting
      # packets from files.
      def read_packets(fname,&block)
        count = 0
        packets = [] unless block
        read_packet_bytes(fname) do |packet| 
          if block
            count += 1
            yield Packet.parse(packet)
          else
            packets << Packet.parse(packet)
          end
        end
        block ? count : packets
      end

    end

    def initialize(args={})
      init_fields(args)
      @filename = args.delete :filename
      super(args[:endian], args[:head], args[:body])
    end

    # Called by initialize to set the initial fields. 
    def init_fields(args={})
      args[:head] = PcapHeader.new(:endian => args[:endian]).read(args[:head])
      args[:body] = PcapPackets.new(:endian => args[:endian]).read(args[:body])
      return args
    end

    # Returns the object in string form.
    def to_s
      self[:head].to_s + self[:body].map {|p| p.to_s}.join
    end

    # Clears the contents of the PcapFile.
    def clear
      self[:body].clear
    end

    # Reads a string to populate the object. Note that this appends new packets to
    # any existing packets in the PcapFile.
    def read(str)
      force_binary(str)
      self[:head].read str[0,24]
      self[:body].read str
      self
    end

    # Clears the contents of the PcapFile prior to reading in a new string.
    def read!(str)
      clear	
      force_binary(str)
      self.read str
    end

    # A shorthand method for opening a file and reading in the packets. Note
    # that readfile clears any existing packets, since that seems to be the
    # typical use.
    def readfile(file)
      fdata = File.open(file, "rb") {|f| f.read}
      self.read! fdata
    end

    # Calls the class method with this object's @filename
    def read_packet_bytes(fname=@filename,&block)
      raise ArgumentError, "Need a file" unless fname
      return self.class.read_packet_bytes(fname, &block)
    end

    # Calls the class method with this object's @filename
    def read_packets(fname=@filename,&block)
      raise ArgumentError, "Need a file" unless fname
      return self.class.read_packets(fname, &block)
    end

    # file_to_array() translates a libpcap file into an array of packets.
    # Note that this strips out pcap timestamps -- if you'd like to retain
    # timestamps and other libpcap file information, you will want to 
    # use read() instead.
    def file_to_array(args={})
      filename = args[:filename] || args[:file] || args[:f]
      if filename
        self.read! File.open(filename, "rb") {|f| f.read}
      end
      if args[:keep_timestamps] || args[:keep_ts] || args[:ts]
        self[:body].map {|x| {x.timestamp.to_s => x.data.to_s} }
      else
        self[:body].map {|x| x.data.to_s}
      end
    end

    alias_method :f2a, :file_to_array

    # Takes an array of packets (as generated by file_to_array), and writes them
    # to a file. Valid arguments are:
    #
    #   :filename
    #   :array      # Can either be an array of packet data, or a hash-value pair of timestamp => data.
    #   :timestamp  # Sets an initial timestamp
    #   :ts_inc     # Sets the increment between timestamps. Defaults to 1 second.
    #   :append     # If true, then the packets are appended to the end of a file.
    def array_to_file(args={})
      if args.kind_of? Hash
        filename = args[:filename] || args[:file] || args[:f]
        arr = args[:array] || args[:arr] || args[:a]
        ts = args[:timestamp] || args[:ts] || Time.now.to_i
        ts_inc = args[:timestamp_increment] || args[:ts_inc] || 1
        append = !!args[:append]
      elsif args.kind_of? Array
        arr = args
        filename = append = nil
      else
        raise ArgumentError, "Unknown argument. Need either a Hash or Array."
      end
      unless arr.kind_of? Array
        raise ArgumentError, "Need an array to read packets from"
      end
      arr.each_with_index do |p,i|
        if p.kind_of? Hash # Binary timestamps are included
          this_ts = p.keys.first.dup
          this_incl_len = p.values.first.size
          this_orig_len = this_incl_len
          this_data = p.values.first
        else # it's an array
          this_ts = Timestamp.new(:endian => self[:endian], :sec => ts + (ts_inc * i)).to_s
          this_incl_len = p.to_s.size
          this_orig_len = this_incl_len
          this_data = p.to_s
        end
        this_pkt = PcapPacket.new({:endian => self[:endian],
                                  :timestamp => this_ts,
                                  :incl_len => this_incl_len,
                                  :orig_len => this_orig_len,
                                  :data => this_data }
                                 )
        self[:body] << this_pkt
      end
      if filename
        self.to_f(:filename => filename, :append => append)
      else
        self
      end
    end

    alias_method :a2f, :array_to_file

    # Just like array_to_file, but clears any existing packets from the array first.
    def array_to_file!(arr)
      clear
      array_to_file(arr)
    end

    alias_method :a2f!, :array_to_file!

    # Writes the PcapFile to a file. Takes the following arguments:
    #
    #   :filename # The file to write to.
    #   :append   # If set to true, the packets are appended to the file, rather than overwriting.
    def to_file(args={})
      filename = args[:filename] || args[:file] || args[:f]
      unless (!filename.nil? || filename.kind_of?(String))
        raise ArgumentError, "Need a :filename for #{self.class}"
      end
      append = args[:append]
      if append
        if File.exists? filename
          File.open(filename,'ab') {|file| file.write(self.body.to_s)}
        else
          File.open(filename,'wb') {|file| file.write(self.to_s)}
        end
      else
        File.open(filename,'wb') {|file| file.write(self.to_s)}
      end
      [filename, self.body.sz, self.body.size]
    end

    alias_method :to_f, :to_file

    # Shorthand method for writing to a file. Can take either :file => 'name.pcap' or
    # simply 'name.pcap'
    def write(filename='out.pcap')
      if filename.kind_of?(Hash)
        f = filename[:filename] || filename[:file] || filename[:f] || 'out.pcap'
      else
        f = filename.to_s
      end
      self.to_file(:filename => f.to_s, :append => false)
    end

    # Shorthand method for appending to a file. Can take either :file => 'name.pcap' or
    # simply 'name.pcap'
    def append(filename='out.pcap')
      if filename.kind_of?(Hash)
        f = filename[:filename] || filename[:file] || filename[:f] || 'out.pcap'
      else
        f = filename.to_s
      end
      self.to_file(:filename => f, :append => true)
    end

  end
end
