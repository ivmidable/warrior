import Image from "next/image";
import { Inter } from "next/font/google";

const inter = Inter({ subsets: ["latin"] });

export default function Home() {
  return (
    <main
      className={`flex min-h-screen flex-col items-center justify-between p-24 ${inter.className}`}
    >
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm lg:flex">
        <p className="fixed left-0 top-0 flex w-full justify-center border-b border-gray-300 bg-gradient-to-b from-zinc-200 pb-6 pt-8 backdrop-blur-2xl dark:border-neutral-800 dark:bg-zinc-800/30 dark:from-inherit lg:static lg:w-auto  lg:rounded-xl lg:border lg:bg-gray-200 lg:p-4 lg:dark:bg-zinc-800/30">
          Your Puzzle Progress
        </p>

      </div>
      <div className="bg-purple-900 p-2">
      <div
        className="grid grid-cols-4 bg-purple-900 bg-no-repeat bg-center bg-contain w-64 h-96 text-center"
        style={{backgroundImage: "url('/85460-art-puzzle-jigsaw-puzzles-game-video-template.png')"}}
      >
          {[true,false,false,false,true,false,false,true,false,true,false,true,false,true,false,true,false,false,true,false,false,false,true,false,].map((piece, index) => (
          piece ? (
            <div key={index} className="relative">
          <Image src={`/piece-placeholder-${index}.png`} width={64} height={64}  alt={`missing-piece-${index}`} className={`absolute ${index > 19 ? "bottom-0":"top-0"}`}/> 
          </div>
          ): <div key={index} />
        ))}
</div>
</div>
    </main>
  );
}

