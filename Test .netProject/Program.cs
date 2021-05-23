using System;

namespace TestProject
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("What's your name? ");
            string name = Console.ReadLine();
            Console.WriteLine("Have a nice day {0}",name);
            Console.Read();
        }
    }
}
