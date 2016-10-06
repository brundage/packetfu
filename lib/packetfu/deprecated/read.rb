# -*- coding: binary -*-
module PacketFu
  # Read is largely deprecated. It was current in PacketFu 0.2.0, but isn't all that useful
  # in 0.3.0 and beyond. Expect it to go away completely by version 1.0. So, the main use
  # of this class is to learn how to do exactly the same things using the PcapFile object.
  class Read

    class << self

      # Reads the magic string of a pcap file, and determines
      # if it's :little or :big endian.
      def get_byte_order(pcap_file)
        byte_order = ((pcap_file[0,4] == PcapHeader::MAGIC_LITTLE) ? :little : :big)
        return byte_order
      end

      # set_byte_order is pretty much totally deprecated.
      def set_byte_order(byte_order)
        PacketFu.instance_variable_set(:@byte_order,byte_order)
        return true
      end

      # A wrapper for PcapFile#file_to_array, but only returns the array. Actually
      # using the PcapFile object is going to be more useful.
      def file_to_array(args={})
        filename = args[:filename] || args[:file] || args[:out]
        raise ArgumentError, "Need a :filename in string form to read from." if (filename.nil? || filename.class != String)
        PcapFile.new.file_to_array(args)
      end

      alias_method :f2a, :file_to_array

    end
  end
end
