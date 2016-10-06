# -*- coding: binary -*-
module PacketFu
  # Write is largely deprecated. It was current in PacketFu 0.2.0, but isn't all that useful
  # in 0.3.0 and beyond. Expect it to go away completely by version 1.0, as working with
  # PacketFu::PcapFile directly is generally going to be more rewarding.
  class Write

    class << self

      # format_packets: Pretty much totally deprecated.
      def format_packets(args={})
        arr = args[:arr] || args[:array] || []
        ts = args[:ts] || args[:timestamp] || Time.now.to_i
        ts_inc = args[:ts_inc] || args[:timestamp_increment]
        pkts = PcapFile.new.array_to_file(:endian => PacketFu.instance_variable_get(:@byte_order),
                                          :arr => arr,
                                          :ts => ts,
                                          :ts_inc => ts_inc)
        pkts.body
      end

      # array_to_file is a largely deprecated function for writing arrays of pcaps to a file.
      # Use PcapFile#array_to_file instead.
      def array_to_file(args={})
        filename = args[:filename] || args[:file] || args[:out] || :nowrite
        arr = args[:arr] || args[:array] || []
        ts = args[:ts] || args[:timestamp] || args[:time_stamp] || Time.now.to_f
        ts_inc = args[:ts_inc] || args[:timestamp_increment] || args[:time_stamp_increment]
        byte_order = args[:byte_order] || args[:byteorder] || args[:endian] || args[:endianness] || :little
        append = args[:append]
        Read.set_byte_order(byte_order) if [:big, :little].include? byte_order
        pf = PcapFile.new
        pf.array_to_file(:endian => PacketFu.instance_variable_get(:@byte_order),
                         :arr => arr,
                         :ts => ts,
                         :ts_inc => ts_inc)
        if filename && filename != :nowrite
          if append
            pf.append(filename)
          else
            pf.write(filename)
          end
          return [filename,pf.to_s.size,arr.size,ts,ts_inc]
        else
          return [nil,pf.to_s.size,arr.size,ts,ts_inc]
        end

      end

      alias_method :a2f, :array_to_file

      # Shorthand method for appending to a file. Also shouldn't use.
      def append(args={})
        array_to_file(args.merge(:append => true))
      end

    end
  end
end
