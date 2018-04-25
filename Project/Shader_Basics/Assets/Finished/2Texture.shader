Shader "Lecture/Texture"
{
	//Blok Properties pozwala na wyświetlenie edytora dla shadera
	//w Unity, dzięki czemu możemy przypisać wartości w edytorze
	Properties 
	{
		//Deklaracja tekstury 2D
		_MainTex ("Base (RGB)", 2D) = "" {}	
	}

	SubShader
	{
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct appdata {
				float4 vertex : POSITION;
				//Współrzędne teksturowania z wierzchołka
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				//Przekazujemy współrzędne do fragment shadera, ale w tym wypadku będą one zinterpolowane
				//Jeżeli nie chcemy interpolować możemy skorzystać z `nointerpolation` w takim wypadku
				//współrzędna zostanie wzięta z pierwszego wierzchołka danego trójkąta
				float2 uv : TEXCOORD0;
			};

			//Deklarujemy nasz sampler (taka sama nazwa jak w Properties).
			//Wykorzystujemy sampler, ponieważ softwarowe sprawdzanie pikseli byłoby nieefektywne
			//dlatego mamy typ opakowujący naszą teksturę, który sam interpoluje piksele i zwraca nam kolor
			sampler2D _MainTex;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				//Zwyczajne przekazanie współrzędnych teksturowania UV
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				//Za pomocą metody `tex2D` pobieramy dane z tekstury przekazując
				//jej sampler oraz współrzędne, z których chcemy otrzymać piksel
				fixed4 col = tex2D(_MainTex, i.uv);
				//Jeżeli korzystamy z przezroczystych tekstur na nieprzezroczystym obiekcie to
				//może nastąpić "Texture bleeding", czyli będzie widoczny kolor zapisany
				//w pikselach, które są przezroczyste. Można poprawić teksturę, albo przemnożyć przez alpha.
				col.rgb *= col.a;
				return col;
			}
			ENDCG
		}
	}
}
