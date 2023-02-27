using System.IO.Compression;
using System.Text;

namespace p5;

public class z2 {
    
    
    public class CaesarStream
    {
        private int _key;
        private FileStream _stream;

        public CaesarStream(FileStream stream, int key)
        {
            this._key = key;
            this._stream = stream;
        }

        public void Write(String str)
        {
            _stream.Write(new UnicodeEncoding().GetBytes(Encipher(str, _key)));
        }

        public void Read()
        {
            byte[] ans = new byte[_stream.Length];
            _stream.Read(ans);
            string result = System.Text.Encoding.UTF8.GetString(ans);
            Console.WriteLine(Decipher(result, _key));
        }
        private char Cipher(char ch, int key)
        {
            if (!char.IsLetter(ch))
                return ch;

            char offset = char.IsUpper(ch) ? 'A' : 'a';
            return (char)((((ch + key) - offset) % 26) + offset);
        }

        public string Encipher(string input, int key)
        {
            string output = string.Empty;

            foreach (char ch in input)
                output += Cipher(ch, key);

            return output;
        }

        public string Decipher(string input, int key)
        {
            return Encipher(input, 26 + key);
        }
    }

    // public static void Main()
    // {
    //     FileStream fileToWrite = File.Create("./test.txt" );
    //     CaesarStream caeToWrite = new CaesarStream( fileToWrite, 5 );
    //     // 5 to przesunięcie
    //     caeToWrite.Write("Tfsdgdsest");
    //     fileToWrite.Close();
    //
    //     FileStream fileToRead = File.Open( "./test.txt", FileMode.Open );
    //     CaesarStream caeToRead = new CaesarStream( fileToRead, -5 );
    //     // -5 znosi 5
    //     caeToRead.Read();
    //     fileToRead.Close();
    // }
}