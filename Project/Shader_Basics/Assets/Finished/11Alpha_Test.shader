Shader "Lecture/Alpha_Test"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "" {}	
		_Cutout ("Cutout", Range(0, 1)) = 0.5
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
			half _Cutout;

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

				//W niektórych wypadkach rysowanie całkowicie transparentnego obiektu jest zbyt obciążające
				//(wiele pikseli jest rysowanych wiele razy). Zamiast tego można je wyciąć.
				//funkcja `clip(x)` wycina piksele jeżeli x < 0
				clip(col.a - _Cutout);
				return fixed4(col.rgb, 1);
			}
			ENDCG
		}
	}
}
