#!/usr/bin/env ruby
# frozen_string_literal: true

require 'nkf'
require 'socket'

listen_port = ARGV.shift.to_i
irc_server_host = ARGV.shift
irc_server_port = ARGV.shift.to_i
if irc_server_port == 0
  abort(<<-USAGE)
Usage: #$0 listen_port irc_server_host irc_server_port
example: #$0 6668 irc.ircnet.ne.jp 6667
  USAGE
end

Socket.tcp_server_loop(listen_port) do |socket, client_addr|
  begin
    begin
      ircnet_socket = Socket.tcp(irc_server_host, irc_server_port)
      loop do
        rs, = IO.select([socket, ircnet_socket])
        break if rs.empty?
        if rs.include?(ircnet_socket)
          jis_line = ircnet_socket.gets
          socket.puts NKF.nkf('-Jwxm0 --fb-xml', jis_line)
        end
        if rs.include?(socket)
          utf8_line = socket.gets
          ircnet_socket.puts NKF.nkf('-Wjxm0 --fb-xml', utf8_line)
        end
      end
    rescue
      # ignore
    ensure
      ircnet_socket.close if ircnet_socket && !ircnet_socket.closed?
    end
  ensure
    socket.close if !socket.closed?
  end
end
