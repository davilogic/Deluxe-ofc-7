<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DELUXE OFC | Guilda Oficial Free Fire</title>
    <!-- Fontes Futuristas -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500;700;900&family=Rajdhani:wght@400;600;700&display=swap" rel="stylesheet">
    <!-- Supabase Client CDN -->
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
    
    <style>
        :root {
            --primary-red: #ff002b;
            --dark-red: #800015;
            --neon-glow: 0 0 15px rgba(255, 0, 43, 0.8), 0 0 30px rgba(255, 0, 43, 0.4);
            --bg-dark: #070709;
            --card-bg: rgba(18, 12, 16, 0.85);
            --text-light: #f0f0f5;
            --text-muted: #a0a0b0;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            scroll-behavior: smooth;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-light);
            font-family: 'Rajdhani', sans-serif;
            overflow-x: hidden;
            position: relative;
        }

        h1, h2, h3, .cyber-font {
            font-family: 'Orbitron', sans-serif;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        /* TELA DE LOADING (5 SEGUNDOS) */
        #loader-screen {
            position: fixed;
            inset: 0;
            background-color: #050507;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
            transition: opacity 0.8s ease, visibility 0.8s ease;
        }

        .loader-wolf-bg {
            position: absolute;
            inset: 0;
            background: url('logo-lobo.jpg') no-repeat center center/contain;
            opacity: 0.22;
            filter: drop-shadow(0 0 35px var(--primary-red));
            animation: pulseWolf 2.5s infinite alternate;
            pointer-events: none;
        }

        .loader-content {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 520px;
            text-align: center;
        }

        .loader-title {
            font-size: 2.2rem;
            font-weight: 900;
            color: #fff;
            text-shadow: var(--neon-glow);
            margin-bottom: 10px;
        }

        .loader-subtitle {
            color: var(--primary-red);
            font-size: 1.1rem;
            font-weight: 700;
            letter-spacing: 4px;
            margin-bottom: 25px;
        }

        .progress-container {
            width: 100%;
            height: 22px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid var(--primary-red);
            border-radius: 4px;
            padding: 3px;
            box-shadow: 0 0 20px rgba(255, 0, 43, 0.3);
            position: relative;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            width: 0%;
            background: linear-gradient(90deg, var(--dark-red), var(--primary-red), #ff4d6d);
            box-shadow: 0 0 15px var(--primary-red);
            transition: width 0.05s linear;
        }

        .progress-percent {
            font-family: 'Orbitron', sans-serif;
            font-size: 1.3rem;
            font-weight: 700;
            color: #fff;
            margin-top: 10px;
            text-shadow: 0 0 10px var(--primary-red);
        }

        .loader-obs {
            margin-top: 22px;
            padding: 12px 18px;
            background: rgba(255, 0, 43, 0.12);
            border-left: 4px solid var(--primary-red);
            border-right: 4px solid var(--primary-red);
            font-size: 1.05rem;
            font-weight: 700;
            color: #ffffff;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 0 15px rgba(255, 0, 43, 0.2);
            animation: pulseBorder 1.5s infinite alternate;
        }

        /* BACKGROUNDS FIXOS */
        .fixed-bg-layer {
            position: fixed;
            inset: 0;
            z-index: -2;
            background: url('camisa-costas.jpg') no-repeat center center/cover;
            opacity: 0.14;
            filter: contrast(120%) saturate(130%);
        }

        .fixed-wolf-watermark {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 75vw;
            max-width: 750px;
            height: 75vh;
            background: url('logo-lobo.jpg') no-repeat center center/contain;
            opacity: 0.12;
            z-index: -1;
            pointer-events: none;
            animation: floatWolf 6s ease-in-out infinite;
        }

        #particles-canvas {
            position: fixed;
            inset: 0;
            z-index: -1;
            pointer-events: none;
        }

        /* NAVEGAÇÃO */
        header {
            position: fixed;
            top: 0;
            width: 100%;
            padding: 15px 5%;
            background: rgba(7, 7, 9, 0.88);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255, 0, 43, 0.4);
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 1000;
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: #fff;
        }

        .nav-brand img {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            border: 2px solid var(--primary-red);
            box-shadow: var(--neon-glow);
            object-fit: cover;
        }

        .nav-brand span {
            font-family: 'Orbitron', sans-serif;
            font-weight: 900;
            font-size: 1.4rem;
            letter-spacing: 2px;
        }

        .nav-brand span b {
            color: var(--primary-red);
        }

        nav ul {
            display: flex;
            list-style: none;
            gap: 20px;
            align-items: center;
        }

        nav a {
            color: var(--text-light);
            text-decoration: none;
            font-weight: 700;
            font-size: 1.05rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: 0.3s;
            position: relative;
        }

        nav a:hover {
            color: var(--primary-red);
            text-shadow: 0 0 10px var(--primary-red);
        }

        .btn-mod-access {
            background: rgba(255, 0, 43, 0.2);
            border: 1px solid var(--primary-red);
            padding: 6px 14px;
            border-radius: 4px;
            color: #fff;
            cursor: pointer;
            font-family: 'Orbitron', sans-serif;
            font-size: 0.85rem;
            font-weight: 700;
            transition: 0.3s;
        }

        .btn-mod-access:hover {
            background: var(--primary-red);
            box-shadow: var(--neon-glow);
        }

        /* SEÇÃO HERO */
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 120px 8% 60px;
            gap: 40px;
            flex-wrap: wrap;
        }

        .hero-text {
            flex: 1;
            min-width: 300px;
        }

        .badge-top {
            display: inline-block;
            padding: 6px 16px;
            background: rgba(255, 0, 43, 0.15);
            border: 1px solid var(--primary-red);
            color: var(--primary-red);
            font-weight: 700;
            font-size: 0.95rem;
            letter-spacing: 2px;
            margin-bottom: 20px;
            clip-path: polygon(10px 0, 100% 0, calc(100% - 10px) 100%, 0 100%);
        }

        .hero-text h1 {
            font-size: clamp(2.8rem, 5vw, 4.5rem);
            font-weight: 900;
            line-height: 1.1;
            margin-bottom: 15px;
        }

        .hero-text h1 span {
            color: var(--primary-red);
            text-shadow: var(--neon-glow);
        }

        .hero-slogan {
            font-size: 1.5rem;
            font-weight: 700;
            color: #fff;
            letter-spacing: 4px;
            margin-bottom: 20px;
            border-left: 4px solid var(--primary-red);
            padding-left: 15px;
        }

        .hero-text p {
            font-size: 1.2rem;
            color: var(--text-muted);
            line-height: 1.6;
            max-width: 600px;
            margin-bottom: 30px;
        }

        .hero-buttons {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .btn-cyber {
            padding: 14px 32px;
            font-family: 'Orbitron', sans-serif;
            font-weight: 700;
            font-size: 1rem;
            text-decoration: none;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #fff;
            background: var(--primary-red);
            border: none;
            cursor: pointer;
            clip-path: polygon(15px 0, 100% 0, 100% calc(100% - 15px), calc(100% - 15px) 100%, 0 100%, 0 15px);
            box-shadow: var(--neon-glow);
            transition: all 0.3s ease;
        }

        .btn-cyber:hover {
            transform: translateY(-3px) scale(1.03);
            background: #ff1a40;
            box-shadow: 0 0 25px var(--primary-red);
        }

        .btn-cyber-outline {
            background: transparent;
            border: 2px solid var(--primary-red);
            box-shadow: inset 0 0 10px rgba(255, 0, 43, 0.3);
        }

        .hero-logo-box {
            flex: 1;
            min-width: 280px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .wolf-emblem {
            width: 100%;
            max-width: 420px;
            border-radius: 50%;
            border: 3px solid var(--primary-red);
            box-shadow: 0 0 40px rgba(255, 0, 43, 0.6), inset 0 0 30px rgba(255, 0, 43, 0.6);
            animation: floatEmblem 4s ease-in-out infinite;
        }

        section {
            padding: 90px 8%;
            position: relative;
        }

        .section-header {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-header h2 {
            font-size: 2.5rem;
            font-weight: 900;
            color: #fff;
            margin-bottom: 10px;
        }

        .section-header h2 span {
            color: var(--primary-red);
            text-shadow: 0 0 15px rgba(255, 0, 43, 0.6);
        }

        .section-line {
            width: 120px;
            height: 4px;
            background: var(--primary-red);
            margin: 0 auto;
            box-shadow: var(--neon-glow);
        }

        .story-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 40px;
            align-items: center;
        }

        .story-card {
            background: var(--card-bg);
            border: 1px solid rgba(255, 0, 43, 0.4);
            padding: 35px;
            border-radius: 8px;
            backdrop-filter: blur(10px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7);
            position: relative;
            overflow: hidden;
        }

        .story-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: var(--primary-red);
            box-shadow: var(--neon-glow);
        }

        .story-card h3 {
            font-size: 1.6rem;
            color: var(--primary-red);
            margin-bottom: 15px;
        }

        .story-card p {
            font-size: 1.15rem;
            line-height: 1.7;
            color: #ddd;
            margin-bottom: 15px;
        }

        .pillars {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 25px;
        }

        .pillar-item {
            background: rgba(255, 0, 43, 0.1);
            border: 1px solid rgba(255, 0, 43, 0.3);
            padding: 12px;
            text-align: center;
            font-family: 'Orbitron', sans-serif;
            font-weight: 700;
            color: #fff;
            letter-spacing: 1px;
        }

        .guilds-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(290px, 1fr));
            gap: 30px;
        }

        .guild-card {
            background: var(--card-bg);
            border: 1px solid rgba(255, 0, 43, 0.35);
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            transition: 0.4s ease;
        }

        .guild-card.main-guild {
            border: 2px solid var(--primary-red);
            box-shadow: 0 0 30px rgba(255, 0, 43, 0.25);
            transform: scale(1.03);
        }

        .guild-tag {
            display: inline-block;
            background: var(--primary-red);
            color: #fff;
            font-family: 'Orbitron', sans-serif;
            font-size: 0.8rem;
            font-weight: 700;
            padding: 5px 14px;
            border-radius: 20px;
            margin-bottom: 15px;
            box-shadow: var(--neon-glow);
        }

        .guild-card h3 {
            font-size: 1.8rem;
            margin-bottom: 10px;
            color: #fff;
        }

        .guild-id {
            font-family: 'Orbitron', sans-serif;
            color: var(--primary-red);
            font-size: 0.95rem;
            margin-bottom: 15px;
            letter-spacing: 1px;
        }

        .guild-card ul {
            list-style: none;
            text-align: left;
            margin-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 15px;
        }

        .guild-card ul li {
            margin-bottom: 10px;
            font-size: 1.1rem;
            color: #ccc;
        }

        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }

        .gallery-item {
            position: relative;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid rgba(255, 0, 43, 0.4);
            background: #000;
        }

        .gallery-item img {
            width: 100%;
            height: 260px;
            object-fit: cover;
            display: block;
        }

        .gallery-caption {
            position: absolute;
            bottom: 0;
            inset-x: 0;
            background: linear-gradient(transparent, rgba(0, 0, 0, 0.95));
            padding: 20px 15px 15px;
            border-top: 1px solid rgba(255, 0, 43, 0.3);
        }

        .gallery-caption h4 {
            font-family: 'Orbitron', sans-serif;
            color: var(--primary-red);
            font-size: 1.05rem;
            margin-bottom: 4px;
        }

        .gallery-caption p {
            font-size: 0.95rem;
            color: #ddd;
        }

        .recruit-box {
            max-width: 700px;
            margin: 0 auto;
            background: var(--card-bg);
            border: 1px solid var(--primary-red);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 30px rgba(255, 0, 43, 0.2);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-family: 'Orbitron', sans-serif;
            font-size: 0.9rem;
            margin-bottom: 8px;
            color: #fff;
        }

        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            background: rgba(0, 0, 0, 0.6);
            border: 1px solid rgba(255, 0, 43, 0.5);
            color: #fff;
            font-family: 'Rajdhani', sans-serif;
            font-size: 1.1rem;
            border-radius: 4px;
            outline: none;
        }

        /* PAINEL DE MODERAÇÃO (MODAL) */
        #mod-modal {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.92);
            z-index: 99999;
            display: none;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .mod-container {
            background: #0d090d;
            border: 2px solid var(--primary-red);
            width: 100%;
            max-width: 700px;
            max-height: 90vh;
            overflow-y: auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 50px rgba(255, 0, 43, 0.5);
            position: relative;
        }

        .mod-close {
            position: absolute;
            top: 15px;
            right: 20px;
            background: transparent;
            border: none;
            color: #fff;
            font-size: 1.8rem;
            cursor: pointer;
        }

        .mod-close:hover {
            color: var(--primary-red);
        }

        footer {
            background: #040406;
            border-top: 2px solid var(--primary-red);
            padding: 40px 8%;
            text-align: center;
        }

        footer p {
            color: var(--text-muted);
            font-size: 1.05rem;
            margin-top: 10px;
        }

        @keyframes pulseWolf {
            0% { transform: scale(0.96); opacity: 0.18; }
            100% { transform: scale(1.04); opacity: 0.32; }
        }

        @keyframes floatWolf {
            0%, 100% { transform: translate(-50%, -50%) translateY(0px); }
            50% { transform: translate(-50%, -50%) translateY(-15px); }
        }

        @keyframes floatEmblem {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-15px); }
        }

        @keyframes pulseBorder {
            0% { box-shadow: 0 0 5px rgba(255, 0, 43, 0.2); }
            100% { box-shadow: 0 0 20px rgba(255, 0, 43, 0.6); }
        }

        .reveal {
            opacity: 0;
            transform: translateY(35px);
            transition: all 0.8s ease;
        }

        .reveal.active {
            opacity: 1;
            transform: translateY(0);
        }

        @media (max-width: 768px) {
            nav ul { display: none; }
            .hero { padding-top: 100px; text-align: center; }
        }
    </style>
</head>
<body>

    <!-- TELA DE LOADING (5 SEGUNDOS) -->
    <div id="loader-screen">
        <div class="loader-wolf-bg"></div>
        <div class="loader-content">
            <div class="loader-title">DELUXE OFC</div>
            <div class="loader-subtitle">INICIALIZANDO SISTEMA DA ALCATEIA</div>
            
            <div class="progress-container">
                <div class="progress-bar" id="progress-bar"></div>
            </div>
            <div class="progress-percent" id="progress-percent">0%</div>

            <div class="loader-obs" id="loading-obs-text">
                OBS: A GUILDA PRINCIPAL É TOP REGIONAL E LEVEL MÁXIMO (7)
            </div>
        </div>
    </div>

    <!-- BACKGROUNDS FIXOS -->
    <div class="fixed-bg-layer"></div>
    <div class="fixed-wolf-watermark"></div>
    <canvas id="particles-canvas"></canvas>

    <!-- CABEÇALHO -->
    <header>
        <a href="#" class="nav-brand">
            <img src="logo-lobo.jpg" alt="Logo Deluxe OFC">
            <span>DELUXE <b>OFC</b></span>
        </a>
        <nav>
            <ul>
                <li><a href="#inicio">Início</a></li>
                <li><a href="#historia">História & Doka</a></li>
                <li><a href="#guildas">As 3 Guildas</a></li>
                <li><a href="#manto">Manto</a></li>
                <li><a href="#recrutamento">Alistar-se</a></li>
                <li><button class="btn-mod-access" onclick="abrirPainelMod()">🛡️ MODERADOR</button></li>
            </ul>
        </nav>
    </header>

    <!-- HERO SECTION -->
    <section class="hero" id="inicio">
        <div class="hero-text reveal">
            <div class="badge-top" id="site-badge">TOP REGIONAL • RUMO AO TOP BRASIL</div>
            <h1 id="hero-title">SOMOS A <span>DELUXE OFC</span></h1>
            <div class="hero-slogan" id="hero-slogan">NASCIDOS PRA VENCER</div>
            <p id="hero-desc">
                Forjada na garra e na lealdade sob o comando do líder <strong>DOKA</strong>. 
                Hoje dominamos o cenário com <strong>3 guildas ativas</strong>, lideradas pela nossa tropa principal 
                <strong>DELUXE 1 (Nível 7 Máximo & Top Regional)</strong> em busca do topo do Brasil.
            </p>
            <div class="hero-buttons">
                <a href="#recrutamento" class="btn-cyber">Entrar para a Alcateia</a>
                <a href="#guildas" class="btn-cyber btn-cyber-outline">Ver Nossas Guildas</a>
            </div>
        </div>

        <div class="hero-logo-box reveal">
            <img src="logo-lobo.jpg" alt="Mascote Lobo Deluxe" class="wolf-emblem">
        </div>
    </section>

    <!-- HISTÓRIA E LÍDER DOKA -->
    <section id="historia">
        <div class="section-header reveal">
            <h2>A ORIGEM DA <span>ALCATEIA</span></h2>
            <div class="section-line"></div>
        </div>

        <div class="story-grid">
            <div class="story-card reveal">
                <h3>CRIADA PELO LÍDER DOKA</h3>
                <p id="story-text-1">
                    A <strong>DELUXE OFC</strong> nasceu da visão e determinação do líder <strong>DOKA</strong>, 
                    com o objetivo de unir jogadores focados, competitivos e leais dentro do Free Fire.
                </p>
                <div class="pillars">
                    <div class="pillar-item">UNIÃO</div>
                    <div class="pillar-item">FOCO</div>
                    <div class="pillar-item">RESPEITO</div>
                    <div class="pillar-item">EVOLUÇÃO</div>
                </div>
            </div>

            <div class="story-card reveal">
                <h3>O MANTO SAGRADO DA DELUXE</h3>
                <p>
                    Nossa camisa personalizada dentro do jogo carrega a identidade da tropa e a mentalidade vencedora estampada nas costas:
                </p>
                <blockquote style="border-left: 3px solid var(--primary-red); padding-left: 15px; font-style: italic; color: #fff; margin: 15px 0;">
                    "Ninguém bebe um gole do seu sofrimento, mas quando é para brindar sua vitória todos querem estar de copo cheio. — DOKA"
                </blockquote>
            </div>
        </div>
    </section>

    <!-- AS 3 GUILDAS DELUXE -->
    <section id="guildas">
        <div class="section-header reveal">
            <h2>IMPÉRIO <span>DELUXE</span> (3 GUILDAS)</h2>
            <div class="section-line"></div>
        </div>

        <div class="guilds-grid">
            <div class="guild-card main-guild reveal">
                <div class="guild-tag">PRINCIPAL • TOP REGIONAL</div>
                <h3 id="g1-nome">DELUXE OFC 1</h3>
                <div class="guild-id" id="g1-id">ID: 2053265505 • NÍVEL 7 (MAX)</div>
                <p style="color: #ddd;" id="g1-desc">A elite da alcateia. Focada em pontuação máxima, Guerra de Guildas e conquista do Top Brasil.</p>
                <ul>
                    <li>Nível Máximo (Nv. 7)</li>
                    <li>Top Regional Consolidado</li>
                    <li>Rumo ao Top Brasil</li>
                    <li>Atividade Semanal Insana</li>
                </ul>
            </div>

            <div class="guild-card reveal">
                <div class="guild-tag">COMPETITIVO & APOIO</div>
                <h3 id="g2-nome">DELUXE OFC 2</h3>
                <div class="guild-id">DIVISÃO DE ELITE • ATIVA</div>
                <p style="color: #ddd;">Segunda força da família Deluxe, formando jogadores de alto nível e dominando as salas.</p>
                <ul>
                    <li>Treinos e X-Treinos Diários</li>
                    <li>Vagas para Line-ups Competitivas</li>
                    <li>Acesso direto à família DOKA</li>
                    <li>Promoção para a Deluxe 1</li>
                </ul>
            </div>

            <div class="guild-card reveal">
                <div class="guild-tag">BASE & RECRUTAMENTO</div>
                <h3 id="g3-nome">DELUXE OFC 3</h3>
                <div class="guild-id">PORTA DE ENTRADA • ATIVA</div>
                <p style="color: #ddd;">Onde novos lobos provam seu valor, evoluem sua jogabilidade e mostram compromisso com a tag.</p>
                <ul>
                    <li>Recrutamento Aberto</li>
                    <li>Foco em Dog Tags e Atividade</li>
                    <li>Evolução Constante</li>
                    <li>Ambiente Unido e Respeitoso</li>
                </ul>
            </div>
        </div>
    </section>

    <!-- GALERIA IN-GAME -->
    <section id="manto">
        <div class="section-header reveal">
            <h2>NOSSO <span>MANTO</span> & CONQUISTAS</h2>
            <div class="section-line"></div>
        </div>

        <div class="gallery-grid">
            <div class="gallery-item reveal">
                <img src="camisa-costas.jpg" alt="Camisa Deluxe Costas">
                <div class="gallery-caption">
                    <h4>MANTO OFICIAL — COSTAS</h4>
                    <p>Estampa exclusiva assinada por DOKA no cofre do jogo.</p>
                </div>
            </div>

            <div class="gallery-item reveal">
                <img src="perfil-guilda.jpg" alt="Perfil Guilda Nível 7">
                <div class="gallery-caption">
                    <h4>DELUXE OFC — NÍVEL 7 MAX</h4>
                    <p>ID 2053265505 • Mais de 477.000 pontos de glória.</p>
                </div>
            </div>

            <div class="gallery-item reveal">
                <img src="camisa-lobby.jpg" alt="Camisa Deluxe Lobby">
                <div class="gallery-caption">
                    <h4>PRESENÇA NO LOBBY</h4>
                    <p>Visual imponente com a camisa oficial da tropa.</p>
                </div>
            </div>

            <div class="gallery-item reveal">
                <img src="mvp-partida.jpg" alt="MVP Contra Squad Deluxe">
                <div class="gallery-caption">
                    <h4>DOMÍNIO EM PARTIDA</h4>
                    <p>13.1 MVP • Superando 95.6% dos jogadores no CS Ranqueado.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- RECRUTAMENTO (LIGADO AO SUPABASE CLOUD) -->
    <section id="recrutamento">
        <div class="section-header reveal">
            <h2>FAÇA PARTE DA <span>DELUXE</span></h2>
            <div class="section-line"></div>
        </div>

        <div class="recruit-box reveal">
            <form id="recruit-form">
                <div class="form-group">
                    <label>SEU NICK NO FREE FIRE</label>
                    <input type="text" id="nick" placeholder="Ex: DLX DOKA" required>
                </div>
                <div class="form-group">
                    <label>SEU ID NO JOGO</label>
                    <input type="number" id="player-id" placeholder="Ex: 15926484470" required>
                </div>
                <div class="form-group">
                    <label>GUILDAS DISPONÍVEIS PARA TESTE</label>
                    <select id="guild-choice">
                        <option value="DELUXE 1 (Principal - Top Regional)">DELUXE 1 (Principal - Top Regional / Requisitos Altos)</option>
                        <option value="DELUXE 2 (Competitivo)">DELUXE 2 (Competitivo)</option>
                        <option value="DELUXE 3 (Recrutamento Geral)">DELUXE 3 (Base & Recrutamento)</option>
                    </select>
                </div>
                <button type="submit" class="btn-cyber" style="width: 100%;">ENVIAR FICHA PARA LIDERANÇA</button>
            </form>
            <div id="form-feedback" style="margin-top: 20px; text-align: center; font-weight: 700; color: #00ff88; display: none;"></div>
        </div>
    </section>

    <!-- MODAL DO PAINEL DO MODERADOR (SENHA OCULTA COM TYPE PASSWORD) -->
    <div id="mod-modal">
        <div class="mod-container">
            <button class="mod-close" onclick="fecharPainelMod()">&times;</button>
            <div id="mod-login-area">
                <h3 style="color: var(--primary-red); margin-bottom: 20px;">🛡️ PAINEL DE MODERAÇÃO</h3>
                <p style="margin-bottom: 15px;">Digite a senha de moderador para gerenciar o site:</p>
                <div class="form-group">
                    <!-- SENHA OCULTADA COM BOLINHAS PARA SEGURANÇA -->
                    <input type="password" id="mod-password-input" placeholder="Digite a senha de acesso">
                </div>
                <button class="btn-cyber" onclick="tentarLoginMod()" style="width: 100%;">ACESSAR PAINEL</button>
                <p id="mod-error-msg" style="color: var(--primary-red); margin-top: 10px; font-weight: bold; display: none;">Senha incorreta!</p>
            </div>

            <div id="mod-dashboard-area" style="display: none;">
                <h3 style="color: var(--primary-red); margin-bottom: 15px;">⚡ GERENCIADOR DO SITE</h3>
                <p style="margin-bottom: 20px; font-size: 0.95rem; color: #aaa;">Altere os textos do site rapidamente.</p>
                
                <div class="form-group">
                    <label>Slogan Principal</label>
                    <input type="text" id="edit-slogan" value="NASCIDOS PRA VENCER">
                </div>
                <div class="form-group">
                    <label>Texto da Barra de Loading (Aviso principal)</label>
                    <input type="text" id="edit-loading-obs" value="OBS: A GUILDA PRINCIPAL É TOP REGIONAL E LEVEL MÁXIMO (7)">
                </div>
                <div class="form-group">
                    <label>Nome da Guilda 1</label>
                    <input type="text" id="edit-g1-name" value="DELUXE OFC 1">
                </div>
                <div class="form-group">
                    <label>ID e Nível da Guilda 1</label>
                    <input type="text" id="edit-g1-id" value="ID: 2053265505 • NÍVEL 7 (MAX)">
                </div>

                <button class="btn-cyber" onclick="salvarAlteracoesMod()" style="width: 100%; margin-top: 10px;">APLICAR ALTERAÇÕES NO SITE</button>
            </div>
        </div>
    </div>

    <!-- RODAPÉ -->
    <footer>
        <h3 class="cyber-font" style="color: #fff; font-size: 1.5rem;">DELUXE <span style="color: var(--primary-red);">OFC</span></h3>
        <p>Líder Fundador: <strong>DOKA</strong> • União • Foco • Respeito • Evolução</p>
        <p style="font-size: 0.9rem; margin-top: 15px;">© 2026 DELUXE OFC Free Fire. Nascidos Pra Vencer.</p>
    </footer>

    <!-- SCRIPTS -->
    <script>
        // CONFIGURAÇÃO DO SUPABASE CLOUD
        const SUPABASE_URL = 'https://vhmynaabviqisxxlakyv.supabase.co';
        const SUPABASE_KEY = 'sb_publishable_AsKvcE7ch1wIHIQbhbCXBw_1QMIJXTy';
        const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

        // 1. TELA DE LOADING (5 SEGUNDOS)
        document.addEventListener("DOMContentLoaded", () => {
            const loaderScreen = document.getElementById('loader-screen');
            const progressBar = document.getElementById('progress-bar');
            const progressPercent = document.getElementById('progress-percent');
            
            const duration = 5000;
            const intervalTime = 50;
            const totalSteps = duration / intervalTime;
            let currentStep = 0;

            const loadingInterval = setInterval(() => {
                currentStep++;
                const percentage = Math.min(Math.round((currentStep / totalSteps) * 100), 100);
                
                progressBar.style.width = percentage + '%';
                progressPercent.textContent = percentage + '%';

                if (currentStep >= totalSteps) {
                    clearInterval(loadingInterval);
                    setTimeout(() => {
                        loaderScreen.style.opacity = '0';
                        loaderScreen.style.visibility = 'hidden';
                    }, 300);
                }
            }, intervalTime);

            carregarDadosSalvos();
        });

        // 2. PAINEL DE MODERAÇÃO
        function abrirPainelMod() {
            document.getElementById('mod-modal').style.display = 'flex';
        }

        function fecharPainelMod() {
            document.getElementById('mod-modal').style.display = 'none';
            document.getElementById('mod-error-msg').style.display = 'none';
            document.getElementById('mod-password-input').value = '';
        }

        function tentarLoginMod() {
            const senha = document.getElementById('mod-password-input').value;
            if (senha === '2012') {
                document.getElementById('mod-login-area').style.display = 'none';
                document.getElementById('mod-dashboard-area').style.display = 'block';
            } else {
                document.getElementById('mod-error-msg').style.display = 'block';
            }
        }

        function salvarAlteracoesMod() {
            const novoSlogan = document.getElementById('edit-slogan').value;
            const novaObs = document.getElementById('edit-loading-obs').value;
            const novoG1Nome = document.getElementById('edit-g1-name').value;
            const novoG1Id = document.getElementById('edit-g1-id').value;

            document.getElementById('hero-slogan').textContent = novoSlogan;
            document.getElementById('loading-obs-text').textContent = novaObs;
            document.getElementById('g1-nome').textContent = novoG1Nome;
            document.getElementById('g1-id').textContent = novoG1Id;

            localStorage.setItem('dlx_slogan', novoSlogan);
            localStorage.setItem('dlx_obs', novaObs);
            localStorage.setItem('dlx_g1name', novoG1Nome);
            localStorage.setItem('dlx_g1id', novoG1Id);

            alert('Alterações aplicadas com sucesso!');
            fecharPainelMod();
        }

        function carregarDadosSalvos() {
            if(localStorage.getItem('dlx_slogan')) {
                document.getElementById('hero-slogan').textContent = localStorage.getItem('dlx_slogan');
                document.getElementById('edit-slogan').value = localStorage.getItem('dlx_slogan');
            }
            if(localStorage.getItem('dlx_obs')) {
                document.getElementById('loading-obs-text').textContent = localStorage.getItem('dlx_obs');
                document.getElementById('edit-loading-obs').value = localStorage.getItem('dlx_obs');
            }
            if(localStorage.getItem('dlx_g1name')) {
                document.getElementById('g1-nome').textContent = localStorage.getItem('dlx_g1name');
                document.getElementById('edit-g1-name').value = localStorage.getItem('dlx_g1name');
            }
            if(localStorage.getItem('dlx_g1id')) {
                document.getElementById('g1-id').textContent = localStorage.getItem('dlx_g1id');
                document.getElementById('edit-g1-id').value = localStorage.getItem('dlx_g1id');
            }
        }

        // 3. ANIMAÇÃO DE SCROLL
        const reveals = document.querySelectorAll('.reveal');
        function checkReveal() {
            const triggerBottom = window.innerHeight * 0.88;
            reveals.forEach(box => {
                const boxTop = box.getBoundingClientRect().top;
                if (boxTop < triggerBottom) {
                    box.classList.add('active');
                }
            });
        }
        window.addEventListener('scroll', checkReveal);
        checkReveal();

        // 4. FORMULÁRIO DE RECRUTAMENTO CONECTADO AO SUPABASE
        document.getElementById('recruit-form').addEventListener('submit', async function(e) {
            e.preventDefault();
            const nick = document.getElementById('nick').value;
            const player_id = document.getElementById('player-id').value;
            const guilda = document.getElementById('guild-choice').value;
            const feedback = document.getElementById('form-feedback');

            // Envia para o Banco Cloud Supabase
            const { data, error } = await supabaseClient
                .from('recrutamento')
                .insert([{ nick: nick, player_id: player_id, guilda: guilda }]);

            feedback.style.display = 'block';
            if (error) {
                feedback.style.color = '#ff002b';
                feedback.innerHTML = `Erro ao enviar ficha: ${error.message}`;
            } else {
                feedback.style.color = '#00ff88';
                feedback.innerHTML = `Ficha registrada na nuvem com sucesso, <strong>${nick}</strong>! <br>A liderança analisará seu perfil em breve.`;
                this.reset();
            }
        });

        // 5. PARTÍCULAS VERMELHAS
        const canvas = document.getElementById('particles-canvas');
        const ctx = canvas.getContext('2d');
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;

        let particlesArray = [];
        class Particle {
            constructor() {
                this.x = Math.random() * canvas.width;
                this.y = Math.random() * canvas.height;
                this.size = Math.random() * 2.5 + 0.5;
                this.speedX = (Math.random() - 0.5) * 0.8;
                this.speedY = (Math.random() - 0.5) * 0.8;
            }
            update() {
                this.x += this.speedX;
                this.y += this.speedY;
                if (this.x < 0 || this.x > canvas.width) this.speedX *= -1;
                if (this.y < 0 || this.y > canvas.height) this.speedY *= -1;
            }
            draw() {
                ctx.fillStyle = 'rgba(255, 0, 43, 0.7)';
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
                ctx.fill();
            }
        }

        function initParticles() {
            particlesArray = [];
            for (let i = 0; i < 65; i++) {
                particlesArray.push(new Particle());
            }
        }

        function animateParticles() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            for (let i = 0; i < particlesArray.length; i++) {
                particlesArray[i].update();
                particlesArray[i].draw();
            }
            requestAnimationFrame(animateParticles);
        }

        window.addEventListener('resize', () => {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            initParticles();
        });

        initParticles();
        animateParticles();
    </script>
</body>
</html>
