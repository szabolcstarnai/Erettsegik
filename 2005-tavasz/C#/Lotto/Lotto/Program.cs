//Feltesszük, hogy a megadott inputfájlok, és a konzolról érkező adatok helyesek, az előfeltételeknek megfelelnek,
//ezért kivétel ellenőrzések nincsenek a kódban

using System;
using System.IO;

namespace Lotto
{
    class Program
    {
        int[,] adatok = new int[52, 5]; //az adatokat egy 52 sorból és 5 oszlopból álló mátrixban tároljuk,
                                        //egy az osztálypéldányhoz tartozó mezőben, így minden metódusban elérhető 
        int[] Bekeres()
        {
            Console.Write("Kérem adja meg az 52. hét lottószámait szóközzel elválasztva: ");
            string[] t = Console.ReadLine().Split();
            int[] be = new int[5];      //biztosan tudjuk, hogy 5 számot kapunk a bemenetről
            for (int i = 0; i < 5; i++) 
            {
                be[i] = int.Parse(t[i]);
            }
            return be;
        }

        void Beolvasas(string adatfajl)
        {
            
            using (StreamReader be = new StreamReader(adatfajl))   //`StreamReader` erőforrás (implementálja az `IDisposable` interfacet), használható `using` kifejezésben,
                                                                   //így a blokk végén automatikusan bezáródik (felszabadul)
            {
                
                for (int i = 0; i < 51; i++) //biztosan tudjuk, hogy 51 sor van
                {
                    string[] t = be.ReadLine().Split();
                    for (int j = 0; j < 5; j++) //biztosan tudjuk, hogy soronként 5 szám van
                    {
                        adatok[i, j] = int.Parse(t[j]);
                    }
                }
            }
        }

        void Kereses(int het)
        {
            Console.Write($"A(z) {het}. hét számai: ");
            for (int i = 0; i < 5; i++)
                Console.Write($"{adatok[het - 1, i]} "); //paraméterként kapott `het`. sor [1..5] adatai (tömbök 0-tól indexeltek, ezért 1-et le kell vonni)
            Console.WriteLine();
        }

        void Feldolgoz(int[] utolso) //kelleni fognak az utolsó hét adatai, ezért átvesszük paraméterben
        {
            //érdemes hatékonyság és kódismétlés elkerülése szempontjából a maradék feladatokat
            //egyben kezelni, mivel mindeyikben a mátrix adatait dolgozzuk fel

            int[] szamok = new int[90]; //5., 8. és 9. feladathoz
            szamok.Initialize(); //feltölti 0 értékekkel
            int ptlan = 0; //6. feladathoz
            for (int i = 0; i < 51; i++)
            {
                for (int j = 0; j < 5; j++)
                {
                    //5. feladat (1/2) - ahol 0 marad, abból a számból nem húztak az 51 hét alatt
                    //8. feladat (1/3), 9. feladat (1/3) - az adatok első fele alapján megállapítani a számok gyakoriságát
                    szamok[adatok[i, j] - 1]++; //a `szamok` 90 elemű tömb egy-egy indexe mutatja, hogy az index-1 számból hány számmal találkoztunk
                    //6. feladat (1/2) - megszámoljuk az 51 hét adatai alapján a páratlan számokat 
                    if (adatok[i, j] % 2 == 1) ptlan++; //ha az éppen feldolgozott szám páratlan, a `ptlan` változó értékét növeljük
                }
            }
            //5. feladat (2/2)
            int k = 0;
            while (k < 90 && szamok[k] != 0) k++; //klasszikus keresés tétele, míg végig nem érünk,
                                                  //vagy nem találunk 0-t, folytatjuk a keresést
            Console.WriteLine(((k == 90) ? "Nem volt" : "Volt") + " olyan szám amit nem húztak ki az 51 hét alatt"); //ha a futóváltózó (`k`) végig ért, akkor nem volt keresett elem
            //6. feladat (2/2)
            Console.WriteLine($"{ptlan} darab páratlan számot húztak ki az 51 hét alatt");
            //7., 8. feladathoz
            for (int i = 0; i < 5; i++)
            {
                //7. feladat (1/2)
                adatok[51, i] = utolso[i]; //az `eheti` tömb adatainak az `adatok` mátrix utolsó sorába való fűzése
                //8. feladat (2/3), 9. feladat (1/3) - számok gyakoriságának frissítése az új adatokkal
                szamok[utolso[i] - 1]++; //`szamok` tömb frissítése a maradék adatok alapján
            }
            //7. feladat (2/2)
            using (StreamWriter ki = new StreamWriter("lotto52.ki")) //`StreamWriter` erőforrás
            {
                for (int i = 0; i < 52; i++)    //`adatok` mátrix 52 sor
                {
                    for (int j = 0; j < 5; j++) //5 oszlop
                    {
                        ki.Write(adatok[i, j]);
                        ki.Write(' ');
                    }
                    ki.Write('\n'); //új sor karakter
                }
            }
            //8. feladat (3/3)
            Console.WriteLine("Számok gyakorisága:");
            int c = 0; //futóváltozó, hányadik számnál tartunk a 90-ből
            for (int i = 0; i < 6; i++)      //6 sorba
            { 
                for (int j = 0; j < 15; j++) //és 15 oszlopba kiírjuk a 90 szám gyakoriságát
                {
                    Console.Write($"{szamok[c++]} "); //kiírjuk a `c`. számot, majd megnöveljük eggyel (c++)
                }
                Console.Write('\n');
            }
            //9. feladat (3/3)
            int[] primek = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89 }; //prímszámok 1-től 90-ig
            Console.Write("Prímszámok 1 és 90 között amiket egyszer sem húztak ki: ");
            for (int i = 0; i < primek.Length; i++)
            {
                if (szamok[primek[i] - 1] == 0)     //végigmegyünk a `primek`-en és minden indexről kinyerjük a számok (`primek[i]`) és
                    Console.Write($"{primek[i]} "); //megnézzük, hogy a `szamok` tömb alapján az adott szám gyakorisága 0-e, ha igen kiírjuk
            }
            Console.WriteLine();
        }

        public static void Main(string[] args)
        {
            Program p = new Program(); 
            //1. feladat
            int[] eheti = p.Bekeres(); //elmentjük a kapott adatokat egy tömbben
            //2. feladat
            Array.Sort(eheti); //beépített rendező algoritmus segítségével rendezzük a tömböt
            Console.Write("A megadott számok rendezve növekvő sorrendben: ");
            Array.ForEach(eheti, x => { Console.Write(x); Console.Write(' '); }); //egyenértékű egy `foreach` blokkal, vagy `for [1..5]` blokkal
                                                                                  //`eheti` tömb minden elemét kiírjuk, majd mögé egy szóközt
                                                                                  //"`x` elemhez hozzárendeljük a blokkot amely kiírja `x`-et és mögé ír egy szóközt"
                                                                                  //alternatívan: x => Console.Write($"{x} ")
            Console.WriteLine();
            //3. feladat
            p.Beolvasas("../../../../../../!Forrasok/lottosz.dat");
            Console.Write("Adja meg a keresett hetet: ");
            int be = int.Parse(Console.ReadLine()); //számként értelmezzük a bementeről érkező adatot és tároljuk
            p.Kereses(be);
            //5., 6., 7., 8., 9. feladat
            p.Feldolgoz(eheti);
            Console.ReadKey();
        }
    }
}
