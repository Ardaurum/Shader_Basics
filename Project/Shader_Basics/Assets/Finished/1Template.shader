//Nazwa Shadera w Unity. Jeżeli skorzystamy z `/` to pojawi się to w menu rozwijanym pod Lecture->Template
Shader "Lecture/Template"
{
	//SubShader zawiera jeden shader. Jeżeli stworzymy kolejny SubShader to następny zastąpi ten
	//jeżeli obecny jest nie wspierany przez kartę graficzną (lub jego ustawienia np. LOD wyłączają go)
	SubShader
	{
		//Każdy Pass to jedna iteracja renderowania. Przy większej ilości Pass kolejne zostaną wykonane
		//po kolei. Jednakże więcej niż jeden nie pozwala na wykorzystanie dynamic batchingu i dodaje kolejne
		//SetCall do karty graficznej.
		Pass {
			//Rozpoczęcie shadera HLSL
			CGPROGRAM
			//Określenie nazwy vertex shadera
			#pragma vertex vert
			//Określenie nazwy fragment (pixel) shadera
			#pragma fragment frag

			//Struktura zawierająca dane wierzchołka. Oprócz POSITION jest jeszcze
			//COLOR, NORMAL, TANGENT i TEXCOORD
			struct appdata {
				//Bierzemy pozycję wierzchołka z modelu
				float4 vertex : POSITION;
			};

			//Struktura do przesłania danych z vertex shader do fragment Shader
			//Pewne opcje jak SV_POSITION zapisują także dane do wyświetlania
			struct v2f {
				//Przekazujemy pozycję wierzchołka na ekranie na wyjściu
				float4 vertex : SV_POSITION;
			};

			//Właściwy blok kodu vertex shadera
			v2f vert(appdata v)
			{
				v2f o;
				//Obliczenie pozycji wierzchołka w przestrzeni ekranu.
				//Równoznaczne z `mul(UNITY_MATRIX_MVP, v.vertex);`.
				//Unity rekomenduje skorzystanie jednak z tej fukcji.
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			//Właściwy blok kodu fragment (pixel) shadera
			//SV_TARGET oznacza że nasza wartość zwracana typu fixed4
			//Zapisuje dane do tekstury.
			fixed4 frag(v2f i) : SV_TARGET
			{
				//Zwracamy kolor zielony (r, g, b, a);
				return fixed4(0, 1, 0, 1);
			}
			ENDCG
		}
	}
}
