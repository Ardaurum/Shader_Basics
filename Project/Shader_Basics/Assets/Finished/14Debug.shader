Shader "Lecture/Vertex_Sine"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "" {}	
		_Factor ("Factor", Range(-10, 10)) = 0
	}

	SubShader
	{
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half _Factor;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				half4 col = tex2D(_MainTex, i.uv);
				//Debugowanie shaderów jest trudniejsze z powodu ich wielowątkowej natury
				//Dlatego najbardziej przydatnym narzędziem jest debuggowanie wizualne
				//poprzez dodawanie linijek zwracających odpowiednie wartości

				//return col;
				col.rgb = col.rgb * sin(_Time.y); //(1 + sin(_Time.y)) / 2.0 * col.rgb * col.a;

				//Na koniec, gdy robimy operację, które mogą wykroczyć poza wartość (0, 1)
				//dobrze jest dać saturate(), który ustawi nam wartości w tym przedziale.
				//W przeciwnym przypadku korzystając z HDR obiekty mogą być zbyt jasne
				//a w przypadku starszych komputerów obiekty mogą stać się nagle czarne
				//lub wystąpić mogą inne artefakty
				return saturate(col);
			}
			ENDCG
		}
	}
}
