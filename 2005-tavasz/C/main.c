#include <stdio.h>

void bekeres(int t[5])
{
    printf("Kerem adja meg az 52. het lottoszamait szokozzel elvalasztva: ");
    for (int i = 0; i < 5; i++)
    {
        scanf("%d", &t[i]);
    }
}

void insertionSort(int *t, size_t n)
{
    for (size_t i = 1; i < n; i++)
    {
        if (t[i - 1] > t[i])
        {
            int x = t[i];
            t[i] = t[i - 1];
            int j = i - 2;
            while (j > -1 && t[j] > x)
            {
                t[j + 1] = t[j];
                j--;
            }
            t[j + 1] = x;
        }
    }
}

void beolvasas(int t[52][5], char *filename)
{
    FILE *input = fopen(filename, "r");
    if (input == NULL)
    {
        fprintf(stderr, "Nem letező fajl, vagy nincs jogosultsag megnyitni\n");
    }
    for (int i = 0; i < 52; i++)
    {
        for (int j = 0; j < 5; j++)
        {
            fscanf(input, "%d", &t[i][j]);
        }
    }
    fclose(input);
}

void feldolgoz(int adatok[52][5], int eheti[5])
{
    int szamok[90];
    int ptlan = 0;
    for (size_t i = 0; i < 90; i++)
    {
        szamok[i] = 0;
    }
    for (size_t i = 0; i < 51; i++)
    {
        for (size_t j = 0; j < 5; j++)
        {
            szamok[adatok[i][j] - 1]++;
            if (adatok[i][j] % 2 == 1)
                ptlan++;
        }
    } //ezen a ponton rendelkezesre all minden szam gyakorisaga az 51 hetrol, es hany paratlan szam volt
    int k = 0;
    while (k < 90 && szamok[k] != 0)
        k++;
    //5. feladat
    printf((k == 90 ? "Nem volt" : "Volt"));
    printf(" olyan szam amit nem huztak ki az 51 het alatt\n");
    //6. feladat
    printf("%d darab paratlan szamot huztak ki az 51 het alatt\n", ptlan);
    //7. feladat
    for (size_t i = 0; i < 5; i++)
    {
        adatok[51][i] = eheti[i];
        szamok[eheti[i] - 1]++;
    }
    FILE *output = fopen("lotto52.ki", "w");
    if (output == NULL)
    {
        fprintf(stderr, "Nincs jogosultsag latrehozni\n");
    }
    for (size_t i = 0; i < 52; i++)
    {
        for (size_t j = 0; j < 5; j++)
        {
            fprintf(output, "%d ", adatok[i][j]);
        }
        fprintf(output, "\n");
    }
    fclose(output);
    //8. feladat
    int c = 0;
    printf("Szamok gyakorisaga:\n");
    for (size_t i = 0; i < 6; i++)
    {
        for (size_t j = 0; j < 15; j++)
        {
            printf("%d ", szamok[c++]);
        }
        printf("\n");
    }
    int primek[] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89};
    printf("Primszamok 1 es 90 kozott amiket egyszer sem huztak ki: ");
    for (int i = 0; i < 24; i++)
    {
        if (szamok[primek[i] - 1] == 0)
            printf("%d ", primek[i]);
    }
    printf("\n");
}

int main()
{
    //1. feladat
    int eheti[5];
    bekeres(eheti);
    //2. feladat
    insertionSort(eheti, 5);
    printf("A megadott szamok rendezve novekvo sorrendben: ");
    for (int i = 0; i < 5; i++)
    {
        printf("%d ", eheti[i]);
    }
    printf("\n");
    //3., 4. feladat
    int be;
    printf("Adja meg a keresett hetet: ");
    scanf("%d", &be);
    int adatok[52][5];
    beolvasas(adatok, "..\\!Forrasok\\lottosz.dat");
    printf("A(z) %d. het szamai: ", be);
    for (int j = 0; j < 5; j++)
    {
        printf("%d ", adatok[be - 1][j]);
    }
    printf("\n");
    //a tobbi feladatot erdemes egyben kezelni hatekonysag miatt
    feldolgoz(adatok, eheti);
    return 0;
}
