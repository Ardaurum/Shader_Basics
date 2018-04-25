Shader "Lecture/Texture_UV"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "" {}	
		//Zadeklarowanie jako Range pokaże nam wygodny suwak.
		//Można zadeklarować także jako Float, to wtedy dostaniemy pole do wpisania bez suwaka.
		_UVScale ("UV Scale", Range(0, 1)) = 1
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

			//Nie potrzebujemy 32 bitów, więc korzystamy z half, który na większości urządzeń
			//ma precyzję 16 bitów.
			half _UVScale;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				//Możemy także samemu przesłać skalę, jeżeli chcemy
				//mieć pewność, że jest ona taka sama w `x` oraz `y`
				//lub pomnożyć tylko przez jedną wartość tilingu
				//o.uv = v.uv * _MainTex_ST.xx + _MainTex_ST.zw
				v.uv *= _UVScale;
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
