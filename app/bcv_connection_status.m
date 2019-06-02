function connected = bcv_connection_status()
connected = false;
try
    address = java.net.InetAddress.getByName('www.github.com');
    connected = true;
catch
end
end

