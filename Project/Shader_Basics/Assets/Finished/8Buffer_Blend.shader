Shader "Lecture/Buffer_Blend"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "" {}	
	}

	SubShader
	{
		//Tagi wymagane, aby Unity poprawnie rozpoznało Shader
		//i wykonało sortowanie oraz umieściło w odpowiedniej kolejce renderowania
		Tags { 
			"Queue"="Transparent"
			"RenderType"="Transparent"
		}

		//Blend src dst https://docs.unity3d.com/Manual/SL-Blend.html
		//Src - piksel z naszego obecnego obiektu
		//Dst - piksel z wyrenderowanych obiektów za naszym

		//Blend One One // src.rgb + dst.rgb
		Blend SrcAlpha OneMinusSrcAlpha // src.a * src.rgb + (1 - src.a) * dst.rgb;
		//Operacja między dwoma pikselami, domyślnie jest to Add

		//BlendOp Sub // Blend src - dst
		BlendOp Add // Blend src + dst

		//Shader zostaje bez zmian
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
