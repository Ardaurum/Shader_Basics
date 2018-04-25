Shader "Lecture/ZTest"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "" {}	
	}

	SubShader
	{
		//Shadery mogą także zapisywać do wielu buforów, zazwyczaj zapisywaliśmy do
		//bufora koloru oraz nieświadomie do z bufora (bufora głębokości)
		//ZWrite Off - wyłącza zapis do bufora głębokości

		//ZTest Greater oznazcza, że jak obiekt jest dalej od jakiegoś innego zapisującego do ZBuffora
		//to tylko wtedy zostanie wyrenderowany.
		ZTest Greater // domyślnie Less

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

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb *= col.a;
				return col;
			}
			ENDCG
		}
	}
}
