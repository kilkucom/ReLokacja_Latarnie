#include <stdio.h>
#include <locale.h>
#include <glib.h>
#include <glib/gstdio.h>

// gcc -o permutacje-par permutacje-par.c `pkg-config --libs --cflags glib-2.0`


gchar* duza(const gchar* param)
{

	gchar *name;
	int i,len;
	glong dlug;

	g_return_val_if_fail(param != NULL, NULL);

	name = g_strdup(param);

	/* capitalize first letter */
	// name[0] = g_ascii_toupper(name[0]);
	name[0] = g_unichar_toupper(name[0]);

	dlug = g_utf8_strlen(name,-1);
	len = (int)(dlug);
	for (i = 0; i<len; ++i)
	{
	    if (name[i] == '-')
	    {
		name[i] = ' ';
		if (i+1 < len)
		{
		    /* capitalize first letter of each word */
		    name[i+1] = g_unichar_toupper(name[i+1]);
		}
	    }
	}
	return name;
}


int main(int argc, char** argv) 
{

	setlocale(LC_ALL, "pl_PL.utf8");

	int licznik,dokonca,licznikkombinacji;
	int ile_kombinacji,numerargumentu; 
	gint ile_slow;

	ile_slow=argc-2;

	// g_print("Liczba slow: %i\n", ile_slow);

	licznik=atoi(argv[argc-1]);
	// g_print("Licznik: %i\n", licznik);

	ile_kombinacji=ile_slow-licznik+1;
	for (licznikkombinacji=1;licznikkombinacji<=ile_kombinacji;licznikkombinacji++)
	{
		//g_print(" %izestaw: ",licznikkombinacji);
		for (dokonca=1; dokonca<=licznik; dokonca++)
		{
			// g_print("%s|",tablica_slow[dokonca+licznikkombinacji-2]);
			g_print("%s",argv[dokonca+licznikkombinacji-1]);
			if (dokonca!=licznik) {g_print("_");}
		}
		g_print("|");
		for (dokonca=1; dokonca<=licznik; dokonca++)
		{
			// g_print("%s|",tablica_slow[dokonca+licznikkombinacji-2]);
			g_print("%s",duza(argv[dokonca+licznikkombinacji-1]));
			if (dokonca!=licznik) {g_print("_");}
		}
		g_print("|");
	}

	return 0;
}
