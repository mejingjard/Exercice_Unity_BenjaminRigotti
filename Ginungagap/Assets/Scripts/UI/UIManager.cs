using UnityEngine;
using System.Collections;

namespace UI
{
    public sealed class UIManager : MonoBehaviour
    {
        public CanvasGroup CombatUI;
        public CanvasGroup ExplorationUI;
        public CanvasGroup MenuUI;

        // Use this for initialization
        void Start()
        {
            CombatUI.alpha = 0;
            CombatUI.interactable = false;
            CombatUI.blocksRaycasts = false;
        }

        protected void Update()
        {
            // todo: update exploration/combat UI
        }

        public void DisplayCombatUI()
        {
            CombatUI.alpha = 1;
            CombatUI.interactable = true;
            CombatUI.blocksRaycasts = true;
            //StartCoroutine(Utilities.Fade(CombatUI, 0, 1, 1.0f, Utilities.EaseType.None));
        }

        public void HideCombatUI()
        {
            CombatUI.alpha = 0;
            CombatUI.interactable = false;
            CombatUI.blocksRaycasts = false;
            //StartCoroutine(Utilities.Fade(CombatUI, 1, 0, 1.0f, Utilities.EaseType.None));
        }

        private void DisplayExplorationUI()
        {
            //StartCoroutine(Utilities.Fade(ExplorationUI, 0, 1, 1.0f, Utilities.EaseType.None));
        }

        private void HideExplorationUI()
        {
            //StartCoroutine(Utilities.Fade(ExplorationUI, 1, 0, 1.0f, Utilities.EaseType.None));
        }

        internal class Utilities
        {
            public static IEnumerator Fade(CanvasGroup p_canvas, float p_alphaStart, float p_alphaTarget, float p_duration, EaseType p_easeType)
            {
                float speed = 1.0f / p_duration;

                for (float t = 0.0f; t < 1.0; t += Time.deltaTime * speed)
                {
                    p_canvas.alpha = Mathf.Lerp(p_alphaStart, p_alphaTarget, Ease(t, p_easeType));
                    yield return 0;
                }
            }

            public enum EaseType
            {
                None,
                In,
                Out,
                InOut
            }

            public static float Ease(float p_time, EaseType p_easeType)
            {
                if (p_easeType == EaseType.None)
                {
                    return p_time;
                }
                if (p_easeType == EaseType.In)
                {
                    return Mathf.Lerp(0.0f, 1.0f, 1.0f - Mathf.Cos(p_time * Mathf.PI * 0.5f));
                }
                if (p_easeType == EaseType.Out)
                {
                    return Mathf.Lerp(0.0f, 1.0f, Mathf.Sin(p_time * Mathf.PI * 0.5f));
                }

                return Mathf.SmoothStep(0.0f, 1.0f, p_time);
            }
        }
    }

    public enum EMenuPage
    {
        Null = -1,
        Inventory = 0
    }
}