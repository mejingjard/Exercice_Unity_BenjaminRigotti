// Shader created with Shader Forge Beta 0.36 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.36;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:0,uamb:True,mssp:True,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:1,bsrc:3,bdst:7,culm:0,dpts:2,wrdp:True,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0.1082872,fgcb:0.1865672,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:32719,y:32712|emission-9-OUT,clip-6-OUT;n:type:ShaderForge.SFN_Tex2d,id:2,x:33853,y:32718,ptlb:_DissolveNoise,ptin:__DissolveNoise,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Slider,id:3,x:34026,y:33005,ptlb:_Dissolve,ptin:__Dissolve,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Add,id:4,x:33640,y:32857|A-2-R,B-5-OUT;n:type:ShaderForge.SFN_RemapRange,id:5,x:33853,y:32960,frmn:0,frmx:1,tomn:-1,tomx:1|IN-3-OUT;n:type:ShaderForge.SFN_Clamp01,id:6,x:33456,y:32857|IN-4-OUT;n:type:ShaderForge.SFN_Color,id:7,x:33382,y:32415,ptlb:_GlowColor,ptin:__GlowColor,glob:False,c1:0.4558824,c2:0.8198782,c3:1,c4:1;n:type:ShaderForge.SFN_OneMinus,id:8,x:33382,y:32557|IN-6-OUT;n:type:ShaderForge.SFN_Multiply,id:9,x:33095,y:32523|A-7-RGB,B-8-OUT,C-23-OUT;n:type:ShaderForge.SFN_ValueProperty,id:23,x:33251,y:32714,ptlb:_BloomPower,ptin:__BloomPower,glob:False,v1:1;proporder:2-3-7-23;pass:END;sub:END;*/

Shader "Shader Forge/Dissolve" {
    Properties {
        __DissolveNoise ("_DissolveNoise", 2D) = "white" {}
        __Dissolve ("_Dissolve", Range(0, 1)) = 1
        __GlowColor ("_GlowColor", Color) = (0.4558824,0.8198782,1,1)
        __BloomPower ("_BloomPower", Float ) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform sampler2D __DissolveNoise; uniform float4 __DissolveNoise_ST;
            uniform float __Dissolve;
            uniform float4 __GlowColor;
            uniform float __BloomPower;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float2 node_34 = i.uv0;
                float node_6 = saturate((tex2D(__DissolveNoise,TRANSFORM_TEX(node_34.rg, __DissolveNoise)).r+(__Dissolve*2.0+-1.0)));
                clip(node_6 - 0.5);
////// Lighting:
////// Emissive:
                float3 emissive = (__GlowColor.rgb*(1.0 - node_6)*__BloomPower);
                float3 finalColor = emissive;
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCollector"
            Tags {
                "LightMode"="ShadowCollector"
            }
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCOLLECTOR
            #define SHADOW_COLLECTOR_PASS
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcollector
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform sampler2D __DissolveNoise; uniform float4 __DissolveNoise_ST;
            uniform float __Dissolve;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_COLLECTOR;
                float2 uv0 : TEXCOORD5;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_SHADOW_COLLECTOR(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float2 node_35 = i.uv0;
                float node_6 = saturate((tex2D(__DissolveNoise,TRANSFORM_TEX(node_35.rg, __DissolveNoise)).r+(__Dissolve*2.0+-1.0)));
                clip(node_6 - 0.5);
                SHADOW_COLLECTOR_FRAGMENT(i)
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Cull Off
            Offset 1, 1
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform sampler2D __DissolveNoise; uniform float4 __DissolveNoise_ST;
            uniform float __Dissolve;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float2 node_36 = i.uv0;
                float node_6 = saturate((tex2D(__DissolveNoise,TRANSFORM_TEX(node_36.rg, __DissolveNoise)).r+(__Dissolve*2.0+-1.0)));
                clip(node_6 - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
