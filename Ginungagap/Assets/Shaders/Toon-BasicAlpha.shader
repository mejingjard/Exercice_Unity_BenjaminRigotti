    Shader "Toon/BasicAlpha" {
    Properties {
    _Color ("Main Color", Color) = (.5,.5,.5,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	_BumpMap ("Normalmap", 2D) = "bump" {}
    _ToonShade ("ToonShader Cubemap(RGB)", CUBE) = "" { Texgen CubeNormal }
  
    }
     
    SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="TransparentCutout"} //Change this
    Pass {
    Name "BASE"
    AlphaTest Greater 0.5
    Cull Off //Remove this
    Blend SrcAlpha OneMinusSrcAlpha //Add This
   
     
    CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct appdata members uv_BumpMap)
#pragma exclude_renderers d3d11 xbox360
// Upgrade NOTE: excluded shader from Xbox360; has structs without semantics (struct appdata members uv_BumpMap)
#pragma exclude_renderers xbox360
    #pragma vertex vert
    #pragma fragment frag
    #pragma fragmentoption ARB_precision_hint_fastest
     
    #include "UnityCG.cginc"
     
    sampler2D _MainTex;
    sampler2D _BumpMap;
    samplerCUBE _ToonShade;
    float4 _MainTex_ST;
    float4 _Color;
     
    struct appdata {
    float4 vertex : POSITION;
    float2 texcoord : TEXCOORD0;
    float3 normal : NORMAL;
    float2 uv_BumpMap;
    };
     
    struct v2f {
    float4 pos : POSITION;
    float2 texcoord : TEXCOORD0;
    float3 cubenormal : TEXCOORD1;
    };
     
    v2f vert (appdata v) {
    v2f o;
    o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
    o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
    o.cubenormal = mul (UNITY_MATRIX_MV, float4(v.normal,0));
    return o;
    }
     
    float4 frag (v2f i) : COLOR {
    float4 col = _Color * tex2D(_MainTex, i.texcoord);
    float4 cube = texCUBE(_ToonShade, i.cubenormal);
    return float4(2.0f * cube.rgb * col.rgb, col.a);
    }
    ENDCG
    }
    }
     
    SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="TransparentCutout"} //Change this
    Pass {
    Name "BASE"
    Cull Off //Remove this
    Blend SrcAlpha OneMinusSrcAlpha //Add this
   
    SetTexture [_MainTex] {
    constantColor [_Color]
    Combine texture * constant
    }
    SetTexture [_ToonShade] {
    combine texture * previous DOUBLE, previous
    }
    }
    }
     
    Fallback "VertexLit"
    }