Shader "Lecture/Chess"
{
	Properties {
		_ChessSize ("Chess Size", Range(1, 10)) = 2
		_NoiseSize ("Noise Size", Range(1, 10)) = 2
	}
	SubShader
	{
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct appdata {
				float4 vertex : POSITION;
				half2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 uv : TEXCOORD0;
			};

			half _ChessSize;
			half _NoiseSize;

			//Funkcja losowa jako że nie ma żadnej funkcji dawanej przez hlsl
			//Nie ma też jako takiego pojęcia stanu, dlatego losowość opiera się na danych
			//przesyłanych przez użytkownika (czas, pozycja, wektory normalne, kolor, stałe itp.)
			float random2D(float2 v) {
				//frac aby uzyskać wartość między (0, 1)
				//dot wykonuje proste mnożenie (v.x * 12.9898 + v.y * 78.233)
				//liczby są dobrane tak, aby wartość była jak najbardziej losowa
				//więcej informacji na https://thebookofshaders.com/10/
				return frac(sin(dot(v.xy, float2(12.9898, 78.233))) * 43758.5453123);
			}

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				//Mnożymy nasze współrzędne przez rozmiar szachownicy
				//Odejmujemy 0.5, aby ustawić pola na krańcach
				o.uv = v.uv * (_ChessSize - 0.5);
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				//Tutaj uzyskujemy funkcję piłokształtną z zakresem wartości (0, 2) 
				//Funkcja sinusoidalna, trójkątna oraz prostokątna też by się nadały
				half2 chess = 2.0 * (1 - frac(i.uv));

				//Korzystając z clip(chess - 1.0) pozbywamy się wszystkiego poniżej wartości 1
				//Dzięki czemu otrzymujemy równomiernie rozłożone pola w osi x oraz y
				clip(chess - 1.0);

				//ceil służy nam po to, aby utworzyć efekt rozpikselowania (grupujemy piksele w jeden większy)
				//2.0 * _NoiseSize pozwala nam na uzyskanie odpowiedniej liczby 'pikseli'
				//Następnie losujemy kolor dla danego piksela oraz przemnażamy ją przez czas
				//Do czasu dodana jest 1.0, aby "rozgrzać" (prewarm) naszą animację.
				//Bez tego na samym początku wszystkie piksele będą czarne (_Time.y < 1.0).
				//`frac` wyciąga nam liczbę po przecinku dzięki czemu jesteśmy w zakresie (0, 1)
				return frac(random2D(ceil(2.0 * _NoiseSize * i.uv)) * (_Time.y + 1.0));
			}
			ENDCG
		}
	}
}
