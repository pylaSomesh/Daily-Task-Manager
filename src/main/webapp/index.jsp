<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Daily Task Manager – Organize Your Day, Accomplish More</title>
<style>
/* ── Reset & Tokens ─────────────────────────────────────── */
*, *::before, *::after {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

:root {
	/* palette */
	--bg-0: #080c10;
	--bg-1: #0d1117;
	--bg-2: #161b22;
	--bg-3: #1c2330;
	--border: #21262d;
	--border-light: #30363d;
	/* accents */
	--blue: #4a90d9;
	--blue-dim: rgba(74, 144, 217, 0.18);
	--blue-glow: rgba(74, 144, 217, 0.30);
	--teal: #39d0c4;
	--teal-dim: rgba(57, 208, 196, 0.14);
	--amber: #f0a832;
	--amber-dim: rgba(240, 168, 50, 0.14);
	--rose: #f05c7a;
	--rose-dim: rgba(240, 92, 122, 0.14);
	--green: #3fb950;
	--green-dim: rgba(63, 185, 80, 0.14);
	/* text */
	--tx-1: #e6edf3;
	--tx-2: #8b949e;
	--tx-3: #484f58;
	/* misc */
	--radius-sm: 6px;
	--radius-md: 10px;
	--radius-lg: 16px;
	--radius-xl: 22px;
	--font: 'Segoe UI', system-ui, -apple-system, sans-serif;
	--transition: 0.22s cubic-bezier(0.4, 0, 0.2, 1);
}

html {
	scroll-behavior: smooth;
}

body {
	font-family: var(--font);
	background: var(--bg-0);
	color: var(--tx-1);
	line-height: 1.6;
	-webkit-font-smoothing: antialiased;
	overflow-x: hidden;
}

/* ── Noise overlay ──────────────────────────────────────── */
body::before {
	content: '';
	position: fixed;
	inset: 0;
	background-image:
		url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
	pointer-events: none;
	z-index: 0;
	opacity: 0.6;
}

/* ── Dot grid ───────────────────────────────────────────── */
body::after {
	content: '';
	position: fixed;
	inset: 0;
	background-image: radial-gradient(circle, rgba(74, 144, 217, 0.07) 1px,
		transparent 1px);
	background-size: 32px 32px;
	pointer-events: none;
	z-index: 0;
}

/* ── Nav ────────────────────────────────────────────────── */
nav {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	z-index: 100;
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 0 40px;
	height: 62px;
	background: rgba(8, 12, 16, 0.80);
	backdrop-filter: blur(14px);
	-webkit-backdrop-filter: blur(14px);
	border-bottom: 1px solid var(--border);
}

.nav-logo {
	display: flex;
	align-items: center;
	gap: 10px;
	text-decoration: none;
}

.nav-logo-icon {
	width: 32px;
	height: 32px;
	background: linear-gradient(135deg, var(--blue) 0%, var(--teal) 100%);
	border-radius: var(--radius-sm);
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 2px 12px var(--blue-glow);
	flex-shrink: 0;
}

.nav-logo-icon svg {
	width: 17px;
	height: 17px;
	fill: none;
	stroke: #fff;
	stroke-width: 2.3;
	stroke-linecap: round;
	stroke-linejoin: round;
}

.nav-logo-text {
	font-size: 15px;
	font-weight: 700;
	color: var(--tx-1);
	letter-spacing: -0.3px;
}

.nav-links {
	display: flex;
	align-items: center;
	gap: 10px;
}

.nav-link-ghost {
	padding: 7px 16px;
	border-radius: var(--radius-sm);
	font-size: 14px;
	font-weight: 600;
	color: var(--tx-2);
	text-decoration: none;
	transition: var(--transition);
	border: 1px solid transparent;
}

.nav-link-ghost:hover {
	color: var(--tx-1);
	background: var(--bg-2);
	border-color: var(--border-light);
}

.nav-link-solid {
	padding: 7px 18px;
	border-radius: var(--radius-sm);
	font-size: 14px;
	font-weight: 700;
	color: #fff;
	text-decoration: none;
	background: linear-gradient(135deg, var(--blue) 0%, #3a7bc8 100%);
	transition: var(--transition);
	box-shadow: 0 2px 10px var(--blue-dim);
}

.nav-link-solid:hover {
	transform: translateY(-1px);
	box-shadow: 0 4px 18px var(--blue-glow);
}

/* ── Page wrapper ───────────────────────────────────────── */
main {
	position: relative;
	z-index: 1;
}

/* ── HERO ───────────────────────────────────────────────── */
.hero {
	min-height: 100vh;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	text-align: center;
	padding: 120px 24px 80px;
	position: relative;
	overflow: hidden;
}

/* Large blurred radial lights */
.hero-light {
	position: absolute;
	border-radius: 50%;
	filter: blur(90px);
	pointer-events: none;
	opacity: 0;
	animation: fadeLight 1.4s ease forwards;
}

.hero-light-1 {
	width: 700px;
	height: 500px;
	top: -15%;
	left: 50%;
	transform: translateX(-50%);
	background: radial-gradient(ellipse, rgba(74, 144, 217, 0.18) 0%,
		transparent 70%);
	animation-delay: 0.1s;
}

.hero-light-2 {
	width: 400px;
	height: 400px;
	bottom: 5%;
	left: -8%;
	background: radial-gradient(ellipse, rgba(57, 208, 196, 0.10) 0%,
		transparent 70%);
	animation-delay: 0.4s;
}

.hero-light-3 {
	width: 350px;
	height: 350px;
	bottom: 0;
	right: -5%;
	background: radial-gradient(ellipse, rgba(240, 168, 50, 0.08) 0%,
		transparent 70%);
	animation-delay: 0.5s;
}

@
keyframes fadeLight {to { opacity:1;
	
}

}

/* Badge */
.hero-badge {
	display: inline-flex;
	align-items: center;
	gap: 7px;
	padding: 5px 14px 5px 8px;
	border-radius: 99px;
	border: 1px solid rgba(74, 144, 217, 0.30);
	background: rgba(74, 144, 217, 0.08);
	font-size: 12.5px;
	font-weight: 600;
	color: var(--blue);
	margin-bottom: 28px;
	letter-spacing: 0.3px;
	animation: heroFadeUp 0.7s ease both;
	animation-delay: 0.1s;
}

.hero-badge-dot {
	width: 7px;
	height: 7px;
	border-radius: 50%;
	background: var(--blue);
	box-shadow: 0 0 6px var(--blue);
	animation: dotPulse 2s ease infinite;
}

@
keyframes dotPulse { 0%, 100% {
	opacity: 1;
	transform: scale(1);
}
50%
{
opacity:0.5;
transform:scale(0.75);
}
}

/* Headline */
.hero-headline {
	font-size: clamp(36px, 6.5vw, 72px);
	font-weight: 800;
	letter-spacing: -2px;
	line-height: 1.08;
	max-width: 820px;
	margin-bottom: 24px;
	animation: heroFadeUp 0.7s ease both;
	animation-delay: 0.2s;
}

.hero-headline .grad {
	background: linear-gradient(135deg, var(--blue) 0%, var(--teal) 55%,
		#a8e6ff 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

/* Sub */
.hero-sub {
	font-size: clamp(15px, 2vw, 18px);
	color: var(--tx-2);
	max-width: 560px;
	line-height: 1.7;
	margin-bottom: 44px;
	animation: heroFadeUp 0.7s ease both;
	animation-delay: 0.3s;
}

/* CTA buttons */
.hero-cta {
	display: flex;
	gap: 14px;
	flex-wrap: wrap;
	justify-content: center;
	animation: heroFadeUp 0.7s ease both;
	animation-delay: 0.4s;
}

.btn-primary {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	padding: 13px 32px;
	border-radius: var(--radius-md);
	font-size: 15px;
	font-weight: 700;
	color: #fff;
	text-decoration: none;
	background: linear-gradient(135deg, var(--blue) 0%, #2e6cc7 100%);
	box-shadow: 0 4px 22px var(--blue-glow), 0 1px 0
		rgba(255, 255, 255, 0.12) inset;
	transition: var(--transition);
	position: relative;
	overflow: hidden;
}

.btn-primary::before {
	content: '';
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.14) 0%,
		transparent 60%);
	opacity: 0;
	transition: opacity 0.2s;
}

.btn-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 32px rgba(74, 144, 217, 0.50);
}

.btn-primary:hover::before {
	opacity: 1;
}

.btn-primary:active {
	transform: translateY(0);
}

.btn-secondary {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	padding: 13px 32px;
	border-radius: var(--radius-md);
	font-size: 15px;
	font-weight: 700;
	color: var(--tx-1);
	text-decoration: none;
	background: var(--bg-2);
	border: 1px solid var(--border-light);
	transition: var(--transition);
}

.btn-secondary:hover {
	background: var(--bg-3);
	border-color: #484f58;
	transform: translateY(-2px);
}

.btn-secondary:active {
	transform: translateY(0);
}

.btn-arrow {
	font-size: 17px;
	transition: transform var(--transition);
	display: inline-block;
}

.btn-primary:hover .btn-arrow, .btn-secondary:hover .btn-arrow {
	transform: translateX(3px);
}

/* Scroll hint */
.hero-scroll {
	position: absolute;
	bottom: 28px;
	left: 50%;
	transform: translateX(-50%);
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 6px;
	color: var(--tx-3);
	font-size: 11.5px;
	letter-spacing: 1.2px;
	text-transform: uppercase;
	animation: heroFadeUp 0.7s ease both;
	animation-delay: 0.8s;
}

.scroll-line {
	width: 1px;
	height: 40px;
	background: linear-gradient(to bottom, var(--tx-3), transparent);
	animation: scrollDrop 1.6s ease infinite;
}

@
keyframes scrollDrop { 0% {
	transform: scaleY(0);
	transform-origin: top;
	opacity: 0;
}

40%
{
transform:scaleY(1);
transform-origin:top;
opacity:1;
}

60%
{

transform-origin:bottom;
opacity:1;
}
100%
{scaleY(0);
transform-origin:bottom;
opacity:0;
}
}

@
keyframes heroFadeUp {from { opacity:0;
	transform: translateY(22px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}

/* ── Section shared ─────────────────────────────────────── */
section {
	position: relative;
	z-index: 1;
}

.section-inner {
	max-width: 1100px;
	margin: 0 auto;
	padding: 0 24px;
}

.section-label {
	display: inline-block;
	font-size: 11.5px;
	font-weight: 700;
	letter-spacing: 2px;
	text-transform: uppercase;
	color: var(--blue);
	margin-bottom: 14px;
}

.section-heading {
	font-size: clamp(26px, 4vw, 40px);
	font-weight: 800;
	letter-spacing: -1px;
	color: var(--tx-1);
	margin-bottom: 14px;
	line-height: 1.15;
}

.section-sub {
	font-size: 16px;
	color: var(--tx-2);
	max-width: 520px;
	line-height: 1.7;
}

/* ── FEATURES ───────────────────────────────────────────── */
.features {
	padding: 100px 0 80px;
}

.features-head {
	text-align: center;
	margin-bottom: 64px;
}

.features-head .section-sub {
	margin: 0 auto;
}

/* ── Grid ── */
.features-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
	gap: 22px;
}

/* ── Card ── */
.feat-card {
	background: var(--bg-2);
	border: 1px solid var(--border);
	border-radius: var(--radius-lg);
	padding: 32px 28px;
	position: relative;
	overflow: hidden;
	transition: var(--transition);
	cursor: default;
	/* staggered entrance */
	opacity: 0;
	transform: translateY(28px);
}

.feat-card.visible {
	animation: cardIn 0.55s ease forwards;
}

@
keyframes cardIn {to { opacity:1;
	transform: translateY(0);
}

}

/* top accent line that grows on hover */
.feat-card::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 2px;
	border-radius: 2px 2px 0 0;
	transform: scaleX(0);
	transform-origin: left;
	transition: transform 0.35s ease;
}

.feat-card:hover {
	border-color: var(--border-light);
	transform: translateY(-4px);
}

.feat-card:hover::before {
	transform: scaleX(1);
}

.feat-card:hover .feat-icon-wrap {
	transform: scale(1.08);
}

/* per-card accent */
.feat-card[data-accent="blue"] {
	box-shadow: 0 4px 28px transparent;
}

.feat-card[data-accent="teal"] {
	box-shadow: 0 4px 28px transparent;
}

.feat-card[data-accent="amber"] {
	box-shadow: 0 4px 28px transparent;
}

.feat-card[data-accent="green"] {
	box-shadow: 0 4px 28px transparent;
}

.feat-card[data-accent="blue"]:hover {
	box-shadow: 0 8px 36px var(--blue-dim);
}

.feat-card[data-accent="teal"]:hover {
	box-shadow: 0 8px 36px var(--teal-dim);
}

.feat-card[data-accent="amber"]:hover {
	box-shadow: 0 8px 36px var(--amber-dim);
}

.feat-card[data-accent="green"]:hover {
	box-shadow: 0 8px 36px var(--green-dim);
}

.feat-card[data-accent="blue"]::before {
	background: linear-gradient(90deg, var(--blue), var(--teal));
}

.feat-card[data-accent="teal"]::before {
	background: linear-gradient(90deg, var(--teal), var(--blue));
}

.feat-card[data-accent="amber"]::before {
	background: linear-gradient(90deg, var(--amber), #f07532);
}

.feat-card[data-accent="green"]::before {
	background: linear-gradient(90deg, var(--green), var(--teal));
}

/* icon */
.feat-icon-wrap {
	width: 50px;
	height: 50px;
	border-radius: var(--radius-md);
	display: flex;
	align-items: center;
	justify-content: center;
	margin-bottom: 22px;
	transition: transform var(--transition);
}

.feat-card[data-accent="blue"]  .feat-icon-wrap {
	background: var(--blue-dim);
}

.feat-card[data-accent="teal"]  .feat-icon-wrap {
	background: var(--teal-dim);
}

.feat-card[data-accent="amber"] .feat-icon-wrap {
	background: var(--amber-dim);
}

.feat-card[data-accent="green"] .feat-icon-wrap {
	background: var(--green-dim);
}

.feat-icon-wrap svg {
	width: 24px;
	height: 24px;
	fill: none;
	stroke-width: 2;
	stroke-linecap: round;
	stroke-linejoin: round;
}

.feat-card[data-accent="blue"]  .feat-icon-wrap svg {
	stroke: var(--blue);
}

.feat-card[data-accent="teal"]  .feat-icon-wrap svg {
	stroke: var(--teal);
}

.feat-card[data-accent="amber"] .feat-icon-wrap svg {
	stroke: var(--amber);
}

.feat-card[data-accent="green"] .feat-icon-wrap svg {
	stroke: var(--green);
}

.feat-card h3 {
	font-size: 17px;
	font-weight: 700;
	color: var(--tx-1);
	margin-bottom: 9px;
	letter-spacing: -0.2px;
}

.feat-card p {
	font-size: 14.5px;
	color: var(--tx-2);
	line-height: 1.65;
}

/* ── ABOUT ──────────────────────────────────────────────── */
.about {
	padding: 32px 0 40px;
}

.about-inner {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 64px;
	align-items: center;
}

.about-content {
	
}

.about-content .section-heading {
	margin-bottom: 18px;
}

.about-content p {
	font-size: 15.5px;
	color: var(--tx-2);
	line-height: 1.8;
	margin-bottom: 14px;
}

.about-content p:last-child {
	margin-bottom: 0;
}

/* ── DIVIDER ────────────────────────────────────────────── */

/* ── FOOTER ─────────────────────────────────────────────── */
footer {
	position: relative;
	z-index: 1;
	border-top: 1px solid var(--border);
	background: var(--bg-1);
	padding: 40px 24px;
}



.footer-inner {
	max-width: 1100px;
	margin: 0 auto;
	display: flex;
	align-items: center;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: 16px;
}

.footer-brand {
	display: flex;
	align-items: center;
	gap: 10px;
	text-decoration: none;
}

.footer-brand-icon {
	width: 28px;
	height: 28px;
	background: linear-gradient(135deg, var(--blue) 0%, var(--teal) 100%);
	border-radius: var(--radius-sm);
	display: flex;
	align-items: center;
	justify-content: center;
}

.footer-brand-icon svg {
	width: 14px;
	height: 14px;
	fill: none;
	stroke: #fff;
	stroke-width: 2.5;
	stroke-linecap: round;
	stroke-linejoin: round;
}

.footer-brand-name {
	font-size: 13.5px;
	font-weight: 700;
	color: var(--tx-2);
}

.footer-copy {
	font-size: 13px;
	color: var(--tx-3);
}

.footer-links {
	display: flex;
	gap: 20px;
}

.footer-links a {
	font-size: 13px;
	color: var(--tx-3);
	text-decoration: none;
	transition: color var(--transition);
}

.footer-links a:hover {
	color: var(--tx-2);
}

.footer-developer a {
    color: inherit;
    text-decoration: none;
}

.footer-developer a:hover {
    color: inherit;
    text-decoration: none;
}
/* ── Responsive ─────────────────────────────────────────── */
@media ( max-width : 900px) {
	nav {
		padding: 0 20px;
	}
	.about-inner {
		grid-template-columns: 1fr;
		gap: 40px;
	}
}

@media ( max-width : 640px) {
	nav {
		padding: 0 16px;
	}
	.nav-logo-text {
		display: none;
	}
	.hero {
		padding: 100px 16px 72px;
	}
	.hero-headline {
		letter-spacing: -1px;
	}
	.btn-primary, .btn-secondary {
		padding: 12px 22px;
		font-size: 14px;
	}
	.features {
		padding: 72px 0 60px;
	}
	.about {
		padding: 24px 0 32px;
	}
	.footer-inner {
		flex-direction: column;
		text-align: center;
	}
	.footer-links {
		justify-content: center;
	}
}
</style>
</head>
<body>

	<!-- ── Nav ──────────────────────────────────────────────────── -->
	<nav role="banner">
		<a href="index.jsp" class="nav-logo"
			aria-label="Daily Task Manager Home"> <span class="nav-logo-icon">
				<svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M9 11l3 3L22 4" />
                <path
						d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11" />
            </svg>
		</span> <span class="nav-logo-text">Daily Task Manager</span>
		</a>
		<div class="nav-links">
			<a href="#features" class="nav-link-ghost">Features</a> <a
				href="#about" class="nav-link-ghost">About</a> <a href="login.jsp"
				class="nav-link-ghost">Login</a> <a href="register.jsp"
				class="nav-link-solid">Get Started</a>
		</div>
	</nav>

	<main>

		<!-- ── HERO ─────────────────────────────────────────────────── -->
		<section class="hero" aria-labelledby="hero-heading">
			<!-- Background lights -->
			<div class="hero-light hero-light-1" aria-hidden="true"></div>
			<div class="hero-light hero-light-2" aria-hidden="true"></div>
			<div class="hero-light hero-light-3" aria-hidden="true"></div>

			<div class="hero-badge" aria-hidden="true">
				<span class="hero-badge-dot"></span> Open Source
			</div>

			<h1 class="hero-headline" id="hero-heading">
				Turn Daily Tasks Into<br> <span class="grad">Daily
					Achievements</span>
			</h1>

			<p class="hero-sub">A clean, fast task manager built on Java
				Servlets, JSP, and MySQL. Create tasks, track progress, and stay
				focused — all in one secure, personal workspace.</p>

			<div class="hero-cta">
				<a href="login.jsp" class="btn-primary"> Sign In <span
					class="btn-arrow" aria-hidden="true">→</span>
				</a> <a href="register.jsp" class="btn-secondary"> Create Account <span
					class="btn-arrow" aria-hidden="true">→</span>
				</a>
			</div>

			<div class="hero-scroll" aria-hidden="true">
				<span>Scroll</span> <span class="scroll-line"></span>
			</div>
		</section>

		<!-- ── FEATURES ─────────────────────────────────────────────── -->
		<section class="features" id="features"
			aria-labelledby="features-heading">
			<div class="section-inner">

				<div class="features-head">
					<span class="section-label">What you get</span>
					<h2 class="section-heading" id="features-heading">Everything
						you need to stay on track</h2>
					<p class="section-sub">Four core pillars that keep your day
						structured, your tasks visible, and your data safe.</p>
				</div>

				<div class="features-grid">

					<!-- Card 1 – Add Tasks -->
					<article class="feat-card" data-accent="blue" data-delay="0">
						<div class="feat-icon-wrap" aria-hidden="true">
							<svg viewBox="0 0 24 24">
                            <line x1="12" y1="5" x2="12" y2="19" />
                            <line x1="5" y1="12" x2="19" y2="12" />
                        </svg>
						</div>
						<h3>Add Tasks</h3>
						<p>Create and manage your daily tasks with ease. Add titles,
							descriptions, and deadlines — then let the app keep track for
							you.</p>
					</article>

					<!-- Card 2 – Track Progress -->
					<article class="feat-card" data-accent="teal" data-delay="100">
						<div class="feat-icon-wrap" aria-hidden="true">
							<svg viewBox="0 0 24 24">
                            <polyline
									points="22 12 18 12 15 21 9 3 6 12 2 12" />
                        </svg>
						</div>
						<h3>Track Progress</h3>
						<p>Mark tasks as completed and watch your productivity grow. A
							clear visual record of what's done and what still needs
							attention.</p>
					</article>

					<!-- Card 3 – Stay Organised -->
					<article class="feat-card" data-accent="amber" data-delay="200">
						<div class="feat-icon-wrap" aria-hidden="true">
							<svg viewBox="0 0 24 24">
                            <rect x="3" y="3" width="7" height="7"
									rx="1" />
                            <rect x="14" y="3" width="7" height="7"
									rx="1" />
                            <rect x="3" y="14" width="7" height="7"
									rx="1" />
                            <rect x="14" y="14" width="7" height="7"
									rx="1" />
                        </svg>
						</div>
						<h3>Stay Organised</h3>
						<p>Keep all your tasks in one place, neatly listed and easy to
							browse. No clutter — just a focused view of your day ahead.</p>
					</article>

					<!-- Card 4 – Secure Access -->
					<article class="feat-card" data-accent="green" data-delay="300">
						<div class="feat-icon-wrap" aria-hidden="true">
							<svg viewBox="0 0 24 24">
                            <rect x="3" y="11" width="18" height="11"
									rx="2" ry="2" />
                            <path d="M7 11V7a5 5 0 0110 0v4" />
                        </svg>
						</div>
						<h3>Secure Access</h3>
						<p>Your data is yours alone. Full user authentication ensures
							a personalised, private task list protected behind your own
							credentials.</p>
					</article>

				</div>
			</div>
		</section>
	<section style="padding: 40px 24px 60px; background: #0d1117;">
			<div style="max-width: 1100px; margin: auto; text-align: center;">
				<h2>What Users Love</h2>
				<p style="margin-top: 20px;">“A simple and powerful way to
					manage daily work.”</p>
				<p>“Helped me stay organized during interview preparation.”</p>
			</div>
		</section>

		<section style="padding: 80px 24px; text-align: center;">
			<h2>Ready To Take Control Of Your Day?</h2>
			<p style="margin: 15px 0;">Create an account and start tracking
				your goals today.</p>
			<a href="register.jsp" class="btn-primary">Get Started Free</a>
		</section>

		<!-- ── ABOUT ─────────────────────────────────────────────────── -->
		<section class="about" id="about" aria-labelledby="about-heading">
			<div class="section-inner">
				<div class="about-inner">

					<div class="about-content">

						<span class="section-label">About this project</span>

						<h2 class="section-heading" id="about-heading">Built for
							productivity, organization, and real-world learning</h2>

						<p>Daily Task Manager is a modern full-stack productivity
							application designed to help users organize, prioritize, and
							complete their daily tasks efficiently.</p>

						<p>The application includes user authentication, priorities,
							due dates, categories, search, filtering, analytics, profile
							management, and password recovery features.</p>

						<p>
							This project was designed and developed by <strong>Somesh
								Pyla</strong> as a practical demonstration of Java web development,
							database integration, security, and modern UI design.
						</p>

					</div>

				</div>
			</div>
		</section>
	</main>

	<!-- ── FOOTER ───────────────────────────────────────────────── -->
	<footer role="contentinfo">
		<div class="footer-inner">

			<a href="index.jsp" class="footer-brand"
				aria-label="Daily Task Manager Home"> <span
				class="footer-brand-icon" aria-hidden="true"> <svg
						viewBox="0 0 24 24">
                    <path d="M9 11l3 3L22 4" />
                    <path
							d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11" />
                </svg>
			</span> <span class="footer-brand-name"> Daily Task Manager </span>

			</a>


			<div class="footer-developer">

    <p>
        Built and Developed by
        <strong>Somesh Pyla</strong>
    </p>

    <p>
        Java Full Stack Developer
    </p>

    <p>
        Support:
        <a href="mailto:dailytaskmanager.project@gmail.com">
            dailytaskmanager.project@gmail.com
        </a>
    </p>

</div>

<p class="footer-copy">
    © <%= java.time.Year.now().getValue() %>
    Daily Task Manager. All Rights Reserved.
</p>
			
			 
  

		</div>
	</footer>

	<script>
		/* ── Intersection Observer: feature card entrance ── */
		(function() {
			var cards = document.querySelectorAll('.feat-card');

			if (!('IntersectionObserver' in window)) {
				cards.forEach(function(c) {
					c.style.opacity = '1';
					c.style.transform = 'none';
				});
				return;
			}

			var obs = new IntersectionObserver(function(entries) {
				entries.forEach(function(entry) {
					if (entry.isIntersecting) {
						var card = entry.target;
						var delay = parseInt(card.getAttribute('data-delay')
								|| '0', 10);
						setTimeout(function() {
							card.classList.add('visible');
						}, delay);
						obs.unobserve(card);
					}
				});
			}, {
				threshold : 0.15
			});

			cards.forEach(function(c) {
				obs.observe(c);
			});
		})();

		/* ── Smooth scroll for anchor links ── */
		document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
			anchor.addEventListener('click', function(e) {
				var target = document.querySelector(this.getAttribute('href'));
				if (target) {
					e.preventDefault();
					target.scrollIntoView({
						behavior : 'smooth',
						block : 'start'
					});
				}
			});
		});

		/* ── Nav background on scroll ── */
		(function() {
			var nav = document.querySelector('nav');
			window.addEventListener('scroll', function() {
				if (window.scrollY > 40) {
					nav.style.borderBottomColor = '#21262d';
				} else {
					nav.style.borderBottomColor = 'transparent';
				}
			}, {
				passive : true
			});
		})();
	</script>

</body>
</html>
