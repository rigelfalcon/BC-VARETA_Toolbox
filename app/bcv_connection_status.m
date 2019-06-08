function connected = bcv_connection_status()
connected = false;
try    
  status = webread('https://www.github.com');        
  connected = true;
catch
end
end

