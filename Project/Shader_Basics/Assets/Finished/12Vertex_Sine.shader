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
				//Manipulacja wierzchołkami polega na zapisaniu odpowiedniej wartości do
				//zmiennej o semantyce SV_POSITION. Należy jednak uważać, aby wierzchołki nie wyszły
				//poza bounding box modelu, w przeciwnym przypadku Unity może nie renderować nadal widocznych obiektów.
				o.vertex = UnityObjectToClipPos(fixed4(v.vertex.xyz * abs(sin(v.vertex.y * _Factor + _Time.y)), 1));
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
