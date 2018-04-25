Shader "Lecture/Back_Culling"
{
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
		_Thickness ("Thickness", Range(0, 2)) = 0.2
	}

	//Prosty shader obrysowujący. Nie działa dla powierzchni
	//prostych (Quad, Cube etc.)
	SubShader
	{
		Pass {
			//Cull Back oznacza, że nie renderujemy ścianek odwróconych do kamery
			Cull Back

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

		Pass {
			//Cull Front rysujemy tylko ścianki celujące w drugą stronę do kamery
			//W przypadku sfery oznacza to, że rysujemy tylko ściany od wewnątrz
			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
			};

			half _Thickness;

			v2f vert(appdata v)
			{
				v2f o;
				//Wymnażamy pozycję wierzchołka z wektorem normalnym wierzchołka oraz podaną grubością
				//Da to nam odrobinę większy model. Rysując tylko wewnętrzne ścianki da to nam obrys.
				o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _Thickness);
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				return fixed4(1, 0, 0, 1);
			}
			ENDCG
		}
	}
}
