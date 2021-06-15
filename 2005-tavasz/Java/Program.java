//Feltesszuk, hogy a megadott inputfajlok, es a konzolrol erkezo adatok helyesek, az elofelteteleknek megfelelnek,
//ezert kivetel ellenorzesek nincsenek a kodban

import java.util.*;
import java.io.*;

public class Program {
	
	int[][] adatok = new int[52][5]; //az adatokat egy 52 sorbol es 5 oszlopbol allo matrixban taroljuk,
                                     //egy az osztalypeldanyhoz tartozo mezoben, igy minden metodusban elerheto 
									 
	int[] bekeres() {
		System.out.print("Kerem adja meg az 52. het lottoszamait szokozzel elvalasztva: ");
		Scanner sc = new Scanner(System.in);
		int[] be = new int[5];      //biztosan tudjuk, hogy 5 szamot kapunk a bemenetrol
		for (int i = 0; i < 5; i++) {
			be[i] = sc.nextInt();
		}
		return be;
	}
	
	void beolvasas(String adatfajl) {
		File input = new File(adatfajl);
		try (BufferedReader br = new BufferedReader(new FileReader(input));) { //`BufferedReader` eroforras (implementalja az `AutoCloseable` interfacet), hasznalhato
                                                                               //`try with resources` kifejezesben, igy a blokk vegen automatikusan bezarodik (felszabadul)
			for (int i = 0; i < 51; i++) { //biztosan tudjuk, hogy 51 sor van
                    String[] t = br.readLine().split(" ");
                    for (int j = 0; j < 5; j++) { //biztosan tudjuk, hogy soronkent 5 szam van
                        adatok[i][j] = Integer.parseInt(t[j]);
                    }
                }
		} catch (FileNotFoundException e) {
			System.out.println("Nem talalhato a fajl");
		} catch (IOException e) {
			System.out.println("IO hiba");
		}
	}
	
	void kereses(int het)
        {
            System.out.print("A(z) " + het + ". het szamai: ");
            for (int i = 0; i < 5; i++)
                System.out.print(adatok[het - 1][i] + " "); //parameterkent kapott `het`. sor [1..5] adatai (tombok 0-tol indexeltek, ezert 1-et le kell vonni)
            System.out.println();
        }
	
	void feldolgoz(int[] utolso) //kelleni fognak az utolso het adatai, ezert atvesszuk parameterben
        {
            //erdemes hatekonysag es kodismetles elkerulese szempontjabol a maradek feladatokat
            //egyben kezelni, mivel mindeyikben a matrix adatait dolgozzuk fel

            int[] szamok = new int[90]; //5., 8. es 9. feladathoz
            int ptlan = 0; //6. feladathoz
            for (int i = 0; i < 51; i++) {
                for (int j = 0; j < 5; j++) {
                    //5. feladat (1/2) - ahol 0 marad, abbol a szambol nem huztak az 51 het alatt
                    //8. feladat (1/3), 9. feladat (1/3) - az adatok elso fele alapjan megallapitani a szamok gyakorisagat
                    szamok[adatok[i][j] - 1]++; //a `szamok` 90 elemu tomb egy-egy indexe mutatja, hogy az index-1 szambol hany szammal talalkoztunk
                    //6. feladat (1/2) - megszamoljuk az 51 het adatai alapjan a paratlan szamokat 
                    if (adatok[i][j] % 2 == 1) ptlan++; //ha az eppen feldolgozott szam paratlan, a `ptlan` valtozo erteket noveljuk
                }
            }
            //5. feladat (2/2)
            int k = 0;
            while (k < 90 && szamok[k] != 0) k++; //klasszikus kereses tetele, mig vegig nem erunk,
                                                  //vagy nem talalunk 0-t, folytatjuk a keresest
            System.out.println(((k == 90) ? "Nem volt" : "Volt") + " olyan szam amit nem huztak ki az 51 het alatt"); //ha a futovaltozo (`k`) vegig ert, akkor nem volt keresett elem
            //6. feladat (2/2)
            System.out.println(ptlan + " darab paratlan szamot huztak ki az 51 het alatt");
            //7., 8. feladathoz
            for (int i = 0; i < 5; i++) {
                //7. feladat (1/2)
                adatok[51][i] = utolso[i]; //az `eheti` tomb adatainak az `adatok` matrix utolso soraba valo fuzese
                //8. feladat (2/3), 9. feladat (1/3) - szamok gyakorisaganak frissitese az uj adatokkal
                szamok[utolso[i] - 1]++; //`szamok` tomb frissitese a maradek adatok alapjan
            }
            //7. feladat (2/2)
			File output = new File("lotto52.ki");
            try (PrintWriter ki = new PrintWriter("lotto52.ki")) //`PrintWriter` eroforras
            {
                for (int i = 0; i < 52; i++) {    //`adatok` matrix 52 sor
                    for (int j = 0; j < 5; j++) { //5 oszlop
                        ki.print(adatok[i][j] + " ");
                    }
                    ki.print('\n'); //uj sor karakter
                }
			} catch (IOException e) {
				System.out.println("IO hiba");
			}
            //8. feladat (3/3)
            System.out.println("Szamok gyakorisaga:");
            int c = 0; //futovaltozo, hanyadik szamnal tartunk a 90-bol
            for (int i = 0; i < 6; i++) {      //6 sorba 
                for (int j = 0; j < 15; j++) { //es 15 oszlopba kiirjuk a 90 szam gyakorisagat
                    System.out.print(szamok[c++] + " "); //kiirjuk a `c`. szamot, majd megnoveljuk eggyel (c++)
                }
                System.out.print('\n');
            }
            //9. feladat (3/3)
            int[] primek = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89 }; //primszamok 1-tol 90-ig
            System.out.print("Primszamok 1 es 90 kozott amiket egyszer sem huztak ki: ");
            for (int i = 0; i < primek.length; i++) {
                if (szamok[primek[i] - 1] == 0)        //vegigmegyunk a `primek`-en es minden indexrol kinyerjuk a szamok (`primek[i]`) es
                    System.out.print(primek[i] + " "); //megnezzuk, hogy a `szamok` tomb alapjan az adott szam gyakorisaga 0-e, ha igen kiirjuk
            }
            System.out.println();
        }
	
	public static void main(String[] args) {
		Program p = new Program(); 
        //1. feladat
        int[] eheti = p.bekeres(); //elmentjuk a kapott adatokat egy tombben
		//2. feladat
		Arrays.sort(eheti); //beepitett rendezo algoritmus segitsegevel rendezzuk a tombot
		System.out.print("A megadott szamok rendezve novekvo sorrendben: ");
        Arrays.stream(eheti).forEach(x -> { System.out.print(x); System.out.print(' '); }); //egyenerteku egy `for (int i : eheti)` blokkal, vagy `for [1..5]` blokkal
                                                                                     //`eheti` tomb minden elemet kiirjuk, majd moge egy szokozt
                                                                                     //"`x` elemhez hozzarendeljuk a blokkot amely kiirja `x`-et es moge ir egy szokozt"
		System.out.println();
		//3. feladat
        p.beolvasas("../!Forrasok/lottosz.dat");
		System.out.print("Adja meg a keresett hetet: ");
        int be = Integer.parseInt(System.console().readLine()); //szamkent ertelmezzuk a bementerol erkezo adatot es taroljuk
        p.kereses(be);
		//5., 6., 7., 8., 9. feladat
        p.feldolgoz(eheti);
	}
}