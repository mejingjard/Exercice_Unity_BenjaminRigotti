// Shader created with Shader Forge Beta 0.36 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.36;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:0,bsrc:0,bdst:0,culm:2,dpts:2,wrdp:True,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0.1082872,fgcb:0.1865672,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:32071,y:32628|diff-17-OUT,emission-43-OUT,clip-2-A;n:type:ShaderForge.SFN_Tex2d,id:2,x:32677,y:32487,ptlb:_Diffuse,ptin:__Diffuse,tex:407f10be0dc82f3439bf6300e61a1dbd,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:16,x:32677,y:32835,ptlb:_GlowMap,ptin:__GlowMap,tex:af5315c95b861e949822bb2ea08bb881,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:17,x:32429,y:32565|A-2-RGB,B-18-RGB;n:type:ShaderForge.SFN_Color,id:18,x:32677,y:32668,ptlb:_DiffuseTint,ptin:__DiffuseTint,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Fresnel,id:42,x:33081,y:32855;n:type:ShaderForge.SFN_Multiply,id:43,x:32451,y:32872|A-16-A,B-106-OUT;n:type:ShaderForge.SFN_Color,id:44,x:32705,y:33165,ptlb:node_44,ptin:_node_44,glob:False,c1:0.8970588,c2:0.8730402,c3:0.02638411,c4:1;n:type:ShaderForge.SFN_Multiply,id:45,x:32499,y:33057|A-131-OUT,B-44-RGB;n:type:ShaderForge.SFN_Multiply,id:76,x:32938,y:32910|A-42-OUT,B-80-OUT;n:type:ShaderForge.SFN_Slider,id:80,x:33066,y:33105,ptlb:_LightCore,ptin:__LightCore,min:0,cur:0.4134501,max:1;n:type:ShaderForge.SFN_Tex2d,id:105,x:32705,y:33334,ptlb:_GlowDiffuse,ptin:__GlowDiffuse,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-114-UVOUT;n:type:ShaderForge.SFN_Multiply,id:106,x:32338,y:33117|A-45-OUT,B-105-RGB;n:type:ShaderForge.SFN_Panner,id:114,x:32927,y:33334,spu:0.02,spv:0.03;n:type:ShaderForge.SFN_OneMinus,id:131,x:32784,y:32996|IN-76-OUT;proporder:2-18-16-44-80-105;pass:END;sub:END;*/

Shader "Shader Forge/Glow_Environment" {
    Properties {
        __Diffuse ("_Diffuse", 2D) = "white" {}
        __DiffuseTint ("_DiffuseTint", Color) = (0.5,0.5,0.5,1)
        __GlowMap ("_GlowMap", 2D) = "white" {}
        _node_44 ("node_44", Color) = (0.8970588,0.8730402,0.02638411,1)
        __LightCore ("_LightCore", Range(0, 1)) = 0.4134501
        __GlowDiffuse ("_GlowDiffuse", 2D) = "white" {}
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
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform sampler2D __Diffuse; uniform float4 __Diffuse_ST;
            uniform sampler2D __GlowMap; uniform float4 __GlowMap_ST;
            uniform float4 __DiffuseTint;
            uniform float4 _node_44;
            uniform float __LightCore;
            uniform sampler2D __GlowDiffuse; uniform float4 __GlowDiffuse_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                float2 node_156 = i.uv0;
                float4 node_2 = tex2D(__Diffuse,TRANSFORM_TEX(node_156.rg, __Diffuse));
                clip(node_2.a - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor + UNITY_LIGHTMODEL_AMBIENT.rgb;
////// Emissive:
                float4 node_157 = _Time + _TimeEditor;
                float2 node_114 = (node_156.rg+node_157.g*float2(0.02,0.03));
                float3 emissive = (tex2D(__GlowMap,TRANSFORM_TEX(node_156.rg, __GlowMap)).a*(((1.0 - ((1.0-max(0,dot(normalDirection, viewDirection)))*__LightCore))*_node_44.rgb)*tex2D(__GlowDiffuse,TRANSFORM_TEX(node_114, __GlowDiffuse)).rgb));
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * (node_2.rgb*__DiffuseTint.rgb);
                finalColor += emissive;
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform sampler2D __Diffuse; uniform float4 __Diffuse_ST;
            uniform sampler2D __GlowMap; uniform float4 __GlowMap_ST;
            uniform float4 __DiffuseTint;
            uniform float4 _node_44;
            uniform float __LightCore;
            uniform sampler2D __GlowDiffuse; uniform float4 __GlowDiffuse_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                float2 node_158 = i.uv0;
                float4 node_2 = tex2D(__Diffuse,TRANSFORM_TEX(node_158.rg, __Diffuse));
                clip(node_2.a - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * (node_2.rgb*__DiffuseTint.rgb);
/// Final Color:
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCollector"
            Tags {
                "LightMode"="ShadowCollector"
            }
            Cull Off
            
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
            uniform sampler2D __Diffuse; uniform float4 __Diffuse_ST;
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
                float2 node_160 = i.uv0;
                float4 node_2 = tex2D(__Diffuse,TRANSFORM_TEX(node_160.rg, __Diffuse));
                clip(node_2.a - 0.5);
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
            uniform sampler2D __Diffuse; uniform float4 __Diffuse_ST;
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
                float2 node_161 = i.uv0;
                float4 node_2 = tex2D(__Diffuse,TRANSFORM_TEX(node_161.rg, __Diffuse));
                clip(node_2.a - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
